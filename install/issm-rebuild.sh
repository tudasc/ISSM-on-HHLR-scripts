#!/bin/bash
set -e

export ISSM_SOURCE_DIR="$PWD/.."
export ISSM_DIR="$PWD/.."

source ../etc/env-issm.sh

source ./env-build.sh

export SCOREP_WRAPPER=OFF
if [ $SCOREP_INSTRUMENTATION -eq 1 ]
then
  export SCOREP_WRAPPER=ON
fi

make V=1 -j $(cat /proc/cpuinfo | grep processor | wc -l)
make V=1
make install

