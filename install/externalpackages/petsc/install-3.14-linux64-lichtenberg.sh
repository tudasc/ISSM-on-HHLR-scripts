#!/bin/sh
set -eu

#Some cleanup
rm -rf install petsc

#Download from ISSM server
git clone -b release https://gitlab.com/petsc/petsc.git petsc
cd petsc
git checkout v3.14.4
#wget https://www.mcs.anl.gov/petsc/mirror/release-snapshots/petsc-3.13.6.tar.gz

#Untar and move petsc to install directory
#tar -zxvf petsc-3.13.6.tar.gz
#mv petsc-3.13.6/* src/
#rm -rf petsc-3.13.6

module load python

export CFLAGS="-O2 -g"
export CXXFLAGS="-O2 -g"
export FFLAGS="-O2 -g"
export COPTFLAGS="-O2 -g"
export CXXOPTFLAGS="-O2 -g"
export FOPTFLAGS="-O2 -g"

#configure
./config/configure.py \
  --prefix="$ISSM_DIR/externalpackages/petsc/install" \
  --with-mpi-dir="$OPENMPI_ROOT" \
  --PETSC_DIR="$ISSM_DIR/externalpackages/petsc/petsc" \
  --with-debugging=0 \
  --with-valgrind=0 \
  --with-x=0 \
  --with-ssl=0 \
  CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" FFLAGS="$FFLAGS" \
  COPTFLAGS="$COPTFLAGS" CXXOPTFLAGS="$CXXOPTFLAGS" FOPTFLAGS="$FOPTFLAGS" \
  --with-shared-libraries=1 \
  --download-metis=1 \
  --download-parmetis=1 \
  --download-mumps=1 \
  --download-scalapack=1 \
  --download-fblaslapack=1 \
  --with-pic=1

#Compile and intall
make V=1 PETSC_DIR=$PWD PETSC_ARCH=arch-linux-c-opt all
make V=1 PETSC_DIR=$PWD PETSC_ARCH=arch-linux-c-opt install

