#!/bin/bash
set -eu

if [ -z "$1" ] || [ ! -d "$1" ]
then
  echo "first parameter is not a directory, please specify issm source dir as first parameter"
  exit 1
fi

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export ISSM_SOURCE_DIR="$1"
export ISSM_BUILD_DIR="$ISSM_SOURCE_DIR/build"
export ISSM_INSTALL_DIR="$ISSM_SOURCE_DIR"
rm -rf $ISSM_BUILD_DIR
mkdir -p $ISSM_BUILD_DIR
cd $ISSM_BUILD_DIR

echo "ISSM directory is $ISSM_SOURCE_DIR"

# copy installation information
mkdir $ISSM_BUILD_DIR/issm-lichtenberg
cp -r $BASEDIR/../* $ISSM_BUILD_DIR/issm-lichtenberg

#setup environment
cp $BASEDIR/etc/env-build.sh .
source ./env-build.sh

mkdir -p $ISSM_INSTALL_DIR/etc
if [ $INSTALL_PETSC -eq 1 ]
then
  cp $BASEDIR/etc/env-issm.sh $ISSM_INSTALL_DIR/etc/env-issm.sh
else
  cp $BASEDIR/etc/env-issm-petsc.sh $ISSM_INSTALL_DIR/etc/env-issm.sh
fi

export SCOREP_WRAPPER=OFF

#-----------------------------
# install external packages
#-----------------------------

export ISSM_DIR=$ISSM_SOURCE_DIR
cd $ISSM_SOURCE_DIR/externalpackages

if [ $INSTALL_M1QN3 -eq 1 ]
then
  echo "--------------------------------------------------------"
  echo "                   compile m1qn3"
  echo "--------------------------------------------------------"
  cd m1qn3
  FFLAGS="-O2 -g" ./install.sh
  cd ..
  export LIBM1QN3_ROOT=$ISSM_DIR/externalpackages/m1qn3/install
fi

if [ $INSTALL_TRIANGLE -eq 1 ]
then
  echo "--------------------------------------------------------"
  echo "                   compile triangle"
  echo "--------------------------------------------------------"
  cd triangle
  CFLAGS="-O2 -g" ./install-linux.sh
  cd ..
  export LIBTRIANGLE_ROOT=$ISSM_DIR/externalpackages/triangle/install
fi

if [ $INSTALL_PETSC -eq 1 ]
then
  echo "--------------------------------------------------------"
  echo "                   compile petsc"
  echo "--------------------------------------------------------"
  cd petsc
  cp $BASEDIR/externalpackages/petsc/install-$ISSM_PETSC_VERSION-linux64-lichtenberg.sh .
  ./install-$ISSM_PETSC_VERSION-linux64-lichtenberg.sh
  cd ..
fi

cd ..

source etc/env-issm.sh

autoreconf -ivf

cd $ISSM_BUILD_DIR
cp $BASEDIR/issm-configure.sh .

if [ $ISSM_MPI = openmpi ]
then
  export MPI_ROOT=$OPENMPI_ROOT
fi
./issm-configure.sh

if [ $SCOREP_INSTRUMENTATION -eq 1 ]
then
  export SCOREP_WRAPPER=ON
fi

cp $BASEDIR/issm-rebuild.sh $ISSM_BUILD_DIR
#copy runtime initialization files
#configure issm-load.sh
cp $BASEDIR/../load/issm-load.sh $ISSM_DIR
sed -i -e "s|\@ISSM_DIR|$ISSM_DIR|g" $ISSM_DIR/issm-load.sh
sed -i -e "s|\@INSTALL_TRIANGLE|$INSTALL_TRIANGLE|g" $ISSM_DIR/issm-load.sh
sed -i -e "s|\@INSTALL_PETSC|$INSTALL_PETSC|g" $ISSM_DIR/issm-load.sh
sed -i -e "s|\@GCC_VERSION|$ISSM_GCC_VERSION|g" $ISSM_DIR/issm-load.sh
sed -i -e "s|\@MPI_VERSION|$ISSM_MPI_VERSION|g" $ISSM_DIR/issm-load.sh
sed -i -e "s|\@MPI|$ISSM_MPI|g" $ISSM_DIR/issm-load.sh
sed -i -e "s|\@PETSC_VERSION|$ISSM_PETSC_VERSION|g" $ISSM_DIR/issm-load.sh
#configure issmModle.lua
cp $BASEDIR/../load/issmModule.lua $ISSM_DIR
sed -i -e "s|\@ISSM_DIR|$ISSM_DIR|g" $ISSM_DIR/issmModule.lua
sed -i -e "s|\@INSTALL_TRIANGLE|$INSTALL_TRIANGLE|g" $ISSM_DIR/issmModule.lua
sed -i -e "s|\@INSTALL_PETSC|$INSTALL_PETSC|g" $ISSM_DIR/issmModule.lua

if [ $COPY_ISSM_MODULE -eq 1 ]
then
  MODULE=${ISSM_DIR/packages/modules}
  mkdir -p $(dirname "$MODULE")
  cp $ISSM_DIR/issmModule.lua $MODULE.lua
fi

make V=1 -j $(cat /proc/cpuinfo | grep processor | wc -l)
make V=1
make install

