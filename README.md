coupling_xolotl
=====

This is a [MOOSE](https://mooseframework.inl.gov/getting_started/index.html) application wrapping [Xolotl](https://github.com/ORNL-Fusion/xolotl/wiki) a cluster dynamics code.

Here is how to install this application:
```
git clone https://github.com/SciDAC-MOOSE-Xolotl-coupling-group/coupling_xolotl.git
cd coupling_xolotl
git checkout xolotl_plsm
git submodule init
git submodule update
cd moose
./scripts/update_and_rebuild_petsc.sh --download-hdf5
./scripts/update_and_rebuild_libmesh.sh
cd ..
make
```

Tests can be run through:
```
./run_tests
```

If your machine has N cores available the installation can go faster by using:
```
MOOSE_JOBS=N ./scripts/update_and_rebuild_libmesh.sh
```
for libMesh; and:
```
make -j N
```
for the coupling code.

If you want 64bit indices support simply add the `--with-64-bit-indices` option with the PETSc script.

Troubleshouting
------

**PETSc and MUMPS**

If you get an error at the build PETSc step related to the MUMPS package, you can try to download this package [manually](https://bitbucket.org/petsc/pkg-mumps/get/v5.2.1-p2.tar.gz) and point to it through:
```
./scripts/update_and_rebuild_petsc.sh --download-hdf5 --download-mumps=/yourselectedlocation/packagename.tar.gz
```

**Clang and OpenMP**

If you use Clang with OpenMP support but still get an error in the build libmesh step stating that your compiler does not support OpenMP, try setting:
```
export OPENMP_CXXFLAGS='-Xpreprocessor -fopenmp -lomp'
export FFLAGS='-L/usr/local/lib'
```
