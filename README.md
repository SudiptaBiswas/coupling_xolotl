coupling_xolotl
=====

This is a [MOOSE](https://mooseframework.inl.gov/getting_started/index.html) application wrapping [Xolotl](https://github.com/ORNL-Fusion/xolotl/wiki) a cluster dynamics code.

Here is how to install this application:

First setup a conda environment following the steps from [here](https://mooseframework.inl.gov/getting_started/installation/conda.html); install boost with `mamba install boost`.

Then get the code:

```
git clone https://github.com/SciDAC-MOOSE-Xolotl-coupling-group/coupling_xolotl.git
cd coupling_xolotl
git submodule init
git submodule update
make
```

Tests can be run through:
```
./run_tests
```

If your machine has N cores available the installation can go faster by using:
```
make -j N
```

If you have your own Boost installation you can define `BOOST_ROOT` before starting the installation.

Troubleshouting
------

**Clang and OpenMP**

If you use Clang with OpenMP support but still get an error in the build libmesh step stating that your compiler does not support OpenMP, try setting:
```
export OPENMP_CXXFLAGS='-Xpreprocessor -fopenmp -lomp'
export FFLAGS='-L/usr/local/lib'
```
