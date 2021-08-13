#!/bin/bash
set -u

#-----------------------------
# configure the build here
#-----------------------------
# enabled = 1, disabled = 0
export INSTALL_M1QN3=1
export INSTALL_TRIANGLE=1
export INSTALL_PETSC=1

# gcc and llvm are supported
export ISSM_COMPILER=gcc
export ISSM_GCC_VERSION=10.2
export ISSM_LLVM_VERSION=10.0.0

export ISSM_C_COMPILER_FLAGS="-O2 -g -fPIC"
export ISSM_CXX_COMPILER_FLAGS="$ISSM_C_COMPILER_FLAGS"
export ISSM_FC_COMPILER_FLAGS="-O2 -g -fPIC"

# OpenMPI is supported
export ISSM_MPI=openmpi
export ISSM_MPI_VERSION=4.0.5

# PETSc 3.14 is supported
export ISSM_PETSC_VERSION=3.14

# enabled = 1, disabled = 0
export SCOREP_INSTRUMENTATION=0
export SCOREP_WRAPPER_INSTRUMENTER_FLAGS=""

# enable this to automatically copy the issmModule.lua script into your moduletree if you manage your own moduletree
export COPY_ISSM_MODULE=0

#-----------------------------
# load modules
#-----------------------------

module purge
ml cmake
ml subversion
ml git
ml gcc/$ISSM_GCC_VERSION
if [ $ISSM_COMPILER = llvm ]
then
  ml llvm/$ISSM_LLVM_VERSION
fi
ml $ISSM_MPI/$ISSM_MPI_VERSION
if [ $SCOREP_INSTRUMENTATION -eq 1 ]
then
  if [ $ISSM_COMPILER = gcc ]
  then
    ml scorep/7.0
  elif [ $ISSM_COMPILER = llvm ]
  then
    ml scorep/7.0
  fi
fi
if [ $INSTALL_M1QN3 -eq 0 ]
then
  module load libm1qn3
fi
if [ $INSTALL_TRIANGLE -eq 0 ]
then
  module load libtriangle
fi
if [ $INSTALL_PETSC -eq 0 ]
then
  module load PETSc/$ISSM_PETSC_VERSION
fi

#-----------------------------
# setup
#-----------------------------

if [ $ISSM_COMPILER = llvm ]
then
  export OMPI_MPICC=clang
  export OMPI_MPICXX=clang++
fi

if [ $SCOREP_INSTRUMENTATION -eq 1 ]
then
  export CC=scorep-mpicc
  export CXX=scorep-mpicxx
  export FC=scorep-mpif90
  export F77=scorep-mpif77
fi

if [ $SCOREP_INSTRUMENTATION -eq 1 ]
then
  if [ $ISSM_COMPILER = llvm ]
  then
    export ISSM_C_COMPILER_FLAGS="$ISSM_C_COMPILER_FLAGS -finstrument-functions-after-inlining"
    export ISSM_CXX_COMPILER_FLAGS="$ISSM_CXX_COMPILER_FLAGS -finstrument-functions-after-inlining"
  fi
fi

export FCFLAGS="$ISSM_FC_COMPILER_FLAGS"
export CFLAGS="$ISSM_C_COMPILER_FLAGS"
export CXXFLAGS="$ISSM_CXX_COMPILER_FLAGS"

set +u

