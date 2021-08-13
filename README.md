# ISSM on HHLR Scripts

This is a collection of scripts to install and run ISSM on the HHLR (Lichtenberg Cluster) at TU Darmstadt.  
The scripts support gcc (default) and the clang/llvm pipeline and are tested with GCC 8.3, 10.2 and Clang/LLVM 10.0.0.  
Currently only OpenMPI is supported, but it should be relativly easy to use other MPI implementations.  
PETSc is either installed by scripts provided by ISSM (default) or the user speficies a preinstalled PETSc (recommended).  
Furthermore the scripts support instrumentation using Score-P (default=disabled).  

## Build

* get a clean copy of the issm source
* enter the directory *install* of this repository (cd install)
* run *issm-build.sh*, use the absolute path to the ISSM root directory as the first parameter (./issm-build.sh 'absolutepathtoissmdirectory').
    * This will copy all necessary scripts to the ISSM directory including issm-rebuild.sh issm-configure.sh issm-load.sh and the environment scripts
    * note: the parallel compilation causes an error; therefore a sequential build is automatically started after the parallel build crashed
* the following options can be used to configure the build:
    * in file /install/etc/env-build.sh
        * set ISSM_COMPILER to gcc or llvm
        * set INSTALL_PETSC to 0 to use PETSc installation of the moduletree (recommended since building PETSc is expansive)
        * set SCOREP_INSTRUMENTATION to 1 to enable scorep instrumentation
        * specify scorep flags in SCOREP_WRAPPER_INSTRUMENTER_FLAGS
		* in file /install/issm-configure.sh
        * enable matlab support

## Rebuild

* to rebuild ISSM including the setup of the environment, execute the script *issm-rebuild.sh* within the *build* folder of the ISSM directory
* this does not execute *make clean*

## Load

* source the script *issm-load.sh* which is generated in the ISSM directory; this will set up the environment to run ISSM, loading modules and set *ISSM_DIR* and *ISSM_ROOT*
* you might want to use the Lmod script, which is created in the installation directory, in a moduletree

