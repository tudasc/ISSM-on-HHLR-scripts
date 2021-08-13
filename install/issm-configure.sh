#!/bin/bash
set -eu

./../configure \
  --prefix=$ISSM_INSTALL_DIR \
  --without-kriging \
  --with-mpi-include="$MPI_ROOT/include" \
  --with-m1qn3-dir="$LIBM1QN3_ROOT" \
  --with-triangle-dir="$LIBTRIANGLE_ROOT" \
  --with-petsc-dir="$PETSC_ROOT" \
  --with-metis-dir="$PETSC_ROOT" \
  --with-mumps-dir="$PETSC_ROOT" \
  --with-blas-lapack-dir="$LAPACK_ROOT" \
  --with-scalapack-dir="$SCALAPACK_ROOT" \
  --disable-shared \
  CFLAGS="$CFLAGS" \
  CXXFLAGS="$CXXFLAGS" \
  FCFLAGS="$FCFLAGS" \
  LDFLAGS="-lmpi_mpifh -lgfortran"

# --- optional configurations --- #
#  --with-matlab-dir=$MATLAB_ROOT \
#  --disable-static \
#  --disable-shared \
