#!/usr/bin/env python

import matplotlib.pyplot as plt
from   pylab import *

## Parameters
fissionRate = 1.09e-8
fissionYield = 0.25

## Create plots
fig1 = plt.figure()
densityPlot = plt.subplot(111)
fig1 = plt.figure()
sizePlot = plt.subplot(111)

time1, density1, size1 = loadtxt('retentionOut.txt', usecols = (0,1,2) , unpack=True)

densityPlot.plot(time1, density1, lw=8, color='black', ls='-', label='Xolotl', alpha=0.7, marker='o', markersize=10)
densityPlot.plot(time1, time1 * fissionRate * fissionYield, lw=6, color='red', ls='--', label='Expected', alpha=0.7)

##sizePlot.plot(time1, size1, lw=8, color='black', ls='-', label='Xolotl', alpha=0.7, marker='o', markersize=10)

## Plot the legend
l = densityPlot.legend(loc="best")
setp(l.get_texts(), fontsize=20)

## Some shaping
densityPlot.set_xlabel("Time (s)",fontsize=25)
densityPlot.set_ylabel("Xe Content (nm$^{-2}$)",fontsize=25)
densityPlot.grid()
densityPlot.tick_params(axis='both', which='major', labelsize=25)
densityPlot.tick_params(axis='both', which='minor', labelsize=25)
plt.savefig("density_plot.png")

sizePlot.plot(time1, size1, lw=8, color='black', ls='-', label='Xolotl', alpha=0.7, marker='o', markersize=10)
sizePlot.set_xlabel("Time (s)",fontsize=25)
sizePlot.set_ylabel("Average Radius (nm)",fontsize=25)
sizePlot.grid()
sizePlot.tick_params(axis='both', which='major', labelsize=25)
sizePlot.tick_params(axis='both', which='minor', labelsize=25)

plt.savefig("size_plot.png")
## Show the plots
plt.show()
