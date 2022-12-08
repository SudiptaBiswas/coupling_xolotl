#!/usr/bin/env python

import numpy as np
import matplotlib.pyplot as plt
from   pylab import *
import h5py
from matplotlib.colors import LogNorm

## Set the Zero
zero = 1.0e-20

## Set the maximum size of xenon
maxSize = 1000001

## Create plots
fig = plt.figure()
title = 'Xenon Distribution'
fig.suptitle(title,fontsize=22)
xePlot = plt.subplot(111)

## Create lists of file names to read from, associated line colors, labels
name = ['network_0D.h5']
col = ['black']
lab = ['Xolotl']

for i in range(len(name)):
    ## Open the file
    f = h5py.File(name[i], 'r')

    ## Get the TS
    concGroup = f['concentrationsGroup']
    timestep = concGroup.attrs['lastTimeStep']

    ## Open the concentration group
    groupName ='concentrationsGroup/concentration_' + str(timestep)
    concGroup = f[groupName]

    ## Read the concentration and index datasets
    concDset = concGroup['concs']
    indexDset = concGroup['concs_startingIndices']

    ## Read the time at the chosen time step
    time = concGroup.attrs['absoluteTime']

    ## Read how many normal and super clusters there are
    networkGroup = f['networkGroup']
    totalSize = networkGroup.attrs['totalSize']

    ## Create the mesh and data array
    x = np.empty([maxSize])
    xeArray = np.empty([maxSize])
    for j in range(maxSize):
        x[j] = j
        xeArray[j] = zero

    pos = 0 ## if 0D
    for j in range(indexDset[pos], indexDset[pos+1]):
        ## Skip the moments for now
        if (int(concDset[j][0]) > totalSize - 1): continue
        ## Get the cluster bounds
        groupName = str(concDset[j][0])
        clusterGroup = networkGroup[groupName]
        bounds = clusterGroup.attrs['bounds']
        ## Loop on Xe size
        for l in range(bounds[0], bounds[1]+1):
            ## Fill the array
            xeArray[l] = xeArray[l] + concDset[j][1]

    ## Plot the data
    x = np.delete(x,(0), axis=0)
    xeArray = np.delete(xeArray,(0), axis=0)
    xePlot.plot(x, xeArray, lw=4, color=col[i], label=lab[i], alpha=0.75)

## Some formatting
xePlot.set_xlabel("Cluster Size",fontsize=22)
xePlot.set_ylabel("Concentration (# / nm3)",fontsize=22)
xePlot.set_xscale('log')
xePlot.set_yscale('log')
xePlot.tick_params(axis='both', which='major', labelsize=20)
## Plot the legends
l2 = xePlot.legend(loc='best')
setp(l2.get_texts(), fontsize=25)
plt.savefig("size_distribution.png", bbox_inches='tight')
## Show the plots
plt.show()
