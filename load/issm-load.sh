#!/bin/bash
#set -e

INSTALL_PETSC=@INSTALL_PETSC
INSTALL_TRIANGLE=@INSTALL_TRIANGLE

module load gcc/@GCC_VERSION
module load @MPI/@MPI_VERSION

if [ $INSTALL_TRIANGLE -eq 0 ]
then
  module load libtriangle
fi
if [ $INSTALL_PETSC -eq 0 ]
then
  module load PETSc/@PETSC_VERSION
fi
ml papi

export ISSM_DIR="@ISSM_DIR"
export ISSM_ROOT=$ISSM_DIR
source $ISSM_DIR/etc/env-issm.sh

echo ISSM directory is ${ISSM_DIR}

#set +e

