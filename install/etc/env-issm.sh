#!/bin/bash
set -e

# Modifies path-related envrionment variables based on which external packages
# have been installed.
#
# ISSM_DIR and ISSM_ARCH should have been defined already in your shell
# settings file (i.e. .bashrc, .cshrc).
#
# TODO:
# - Condition all path modifications on existence of external package 'install'
#	directory
#

## Functions
#
c_include_path_append(){ #{{{
	if [ -d "${1}" ]; then
		if [ -z $C_INCLUDE_PATH ]; then
			export C_INCLUDE_PATH="${1}"
		elif [[ ":${C_INCLUDE_PATH}:" != *":${1}:"* ]]; then
			export C_INCLUDE_PATH="${C_INCLUDE_PATH}:${1}"
		fi
	fi
} #}}}
c_include_path_prepend(){ #{{{
	if [ -d "${1}" ]; then
		if [ -z $C_INCLUDE_PATH ]; then
			export C_INCLUDE_PATH="${1}"
		elif [[ ":${C_INCLUDE_PATH}:" != *":${1}:"* ]]; then
			export C_INCLUDE_PATH="${1}:${C_INCLUDE_PATH}"
		fi
	fi
} #}}}

cpath_append(){ #{{{
	if [ -d "${1}" ]; then
		if [ -z $CPATH ]; then
			export CPATH="${1}"
		elif [[ ":${CPATH}:" != *":${1}:"* ]]; then
			export CPATH="${CPATH}:${1}"
		fi
	fi
} #}}}
cpath_prepend(){ #{{{
	if [ -d "${1}" ]; then
		if [ -z $CPATH ]; then
			export CPATH="${1}"
		elif [[ ":${CPATH}:" != *":${1}:"* ]]; then
			export CPATH="${1}:${CPATH}"
		fi
	fi
} #}}}

cplus_include_path_append(){ #{{{
	if [ -d "${1}" ]; then
		if [ -z $CPLUS_INCLUDE_PATH ]; then
			export CPLUS_INCLUDE_PATH="${1}"
		elif [[ ":${CPLUS_INCLUDE_PATH}:" != *":${1}:"* ]]; then
			export CPLUS_INCLUDE_PATH="${CPLUS_INCLUDE_PATH}:${1}"
		fi
	fi
} #}}}
cplus_include_path_prepend(){ #{{{
	if [ -d "${1}" ]; then
		if [ -z $CPLUS_INCLUDE_PATH ]; then
			export CPLUS_INCLUDE_PATH="${1}"
		elif [[ ":${CPLUS_INCLUDE_PATH}:" != *":${1}:"* ]]; then
			export CPLUS_INCLUDE_PATH="${1}:${CPLUS_INCLUDE_PATH}"
		fi
	fi
} #}}}

dyld_library_path_append(){ #{{{
	if [ -d "${1}" ]; then
		if [ -z $DYLD_LIBRARY_PATH ]; then
			export DYLD_LIBRARY_PATH="${1}"
		elif [[ ":${DYLD_LIBRARY_PATH}:" != *":${1}:"* ]]; then
			export DYLD_LIBRARY_PATH="${DYLD_LIBRARY_PATH}:${1}"
		fi
		if [ -z $LD_RUN_PATH ]; then
			export LD_RUN_PATH=$1
		elif [[ ":${LD_RUN_PATH}:" != *":${1}:"* ]]; then
			export LD_RUN_PATH="${LD_RUN_PATH}:${1}"
		fi
	fi
} #}}}
dyld_library_path_prepend(){ #{{{
	if [ -d "${1}" ]; then
		if [ -z $DYLD_LIBRARY_PATH ]; then
			export DYLD_LIBRARY_PATH="${1}"
		elif [[ ":${DYLD_LIBRARY_PATH}:" != *":${1}:"* ]]; then
			export DYLD_LIBRARY_PATH="${1}:${DYLD_LIBRARY_PATH}"
		fi
		if [ -z $LD_RUN_PATH ]; then
			export LD_RUN_PATH="${1}"
		elif [[ ":${LD_RUN_PATH}:" != *":${1}:"* ]]; then
			export LD_RUN_PATH="${1}:${LD_RUN_PATH}"
		fi
	fi
} #}}}

ld_library_path_append(){ #{{{
	if [ -d "${1}" ]; then
		if [ -z $LD_LIBRARY_PATH ]; then
			export LD_LIBRARY_PATH="${1}"
		elif [[ ":${LD_LIBRARY_PATH}:" != *":${1}:"* ]]; then
			export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${1}"
		fi
		if [ -z $LD_RUN_PATH ]; then
			export LD_RUN_PATH="${1}"
		elif [[ ":${LD_RUN_PATH}:" != *":$1:"* ]]; then
			export LD_RUN_PATH="${LD_RUN_PATH}:${1}"
		fi
	fi
} #}}}
ld_library_path_prepend(){ #{{{
	if [ -d "${1}" ]; then
		if [ -z $LD_LIBRARY_PATH ]; then
			export LD_LIBRARY_PATH="${1}"
		elif [[ ":${LD_LIBRARY_PATH}:" != *":${1}:"* ]]; then
			export LD_LIBRARY_PATH="${1}:${LD_LIBRARY_PATH}"
		fi
		if [ -z $LD_RUN_PATH ]; then
			export LD_RUN_PATH="${1}"
		elif [[ ":${LD_RUN_PATH}:" != *":${1}:"* ]]; then
			export LD_RUN_PATH="${1}:${LD_RUN_PATH}"
		fi
	fi
} #}}}

library_path_append(){ #{{{
	if [ -d "${1}" ]; then
		if [ -z $LIBRARY_PATH ]; then
			export LIBRARY_PATH="${1}"
		elif [[ ":${LIBRARY_PATH}:" != *":$1:"* ]]; then
			export LIBRARY_PATH="${LIBRARY_PATH}:${1}"
		fi
	fi
} #}}}
library_path_prepend(){ #{{{
	if [ -d "${1}" ]; then
		if [ -z $LIBRARY_PATH ]; then
			export LIBRARY_PATH="${1}"
		elif [[ ":${LIBRARY_PATH}:" != *":$1:"* ]]; then
			export LIBRARY_PATH="${1}:${LIBRARY_PATH}"
		fi
	fi
} #}}}

path_append(){ #{{{
	if [ -d "${1}" ] && [[ ":${PATH}:" != *":${1}:"* ]]; then
		path="${1}"
		if [[ "${ISSM_ARCH}" == "cygwin-intel" ]]; then
			path=`cygpath -u "${1}"`
		fi
		export PATH="${PATH}:${path}"
	fi
} #}}}
path_prepend(){ #{{{
	if [ -d "${1}" ] && [[ ":${PATH}:" != *":${1}:"* ]]; then
		path="${1}"
		if [[ "${ISSM_ARCH}" == "cygwin-intel" ]]; then
			path=`cygpath -u "${1}"`
		fi
		export PATH="${path}:${PATH}"
	fi
} #}}}

# Windows compilers:
if [[ "$ISSM_ARCH" == "cygwin-intel" ]]; then
	source $ISSM_DIR/externalpackages/windows/windows_environment.sh
fi

# Load ISSM scripts
path_append "${ISSM_DIR}/scripts"

SVN_DIR="${ISSM_DIR}/externalpackages/svn/install"
if [ -d "${SVN_DIR}" ]; then
	path_prepend   "${SVN_DIR}/bin"
	ld_library_path_append "${SVN_DIR}/lib"
fi

GIT_DIR="${ISSM_DIR}/externalpackages/git/install"
if [ -d "${GIT_DIR}" ]; then
	path_prepend "${GIT_DIR}/bin"
fi

## MPI_DIR from Lichtenberg

#MPI_DIR="${ISSM_DIR}/externalpackages/mpich/install"
#if [ -d "$MPI_DIR" ]; then
#	export MPI_DIR
#	export MPI_INC_DIR="$MPI_DIR/include"
#	path_prepend "${MPI_DIR}/bin"
#	cpath_prepend "${MPI_DIR}/include"
#	ld_library_path_append "${MPI_DIR}/lib"
#fi

PETSC_DIR="${ISSM_DIR}/externalpackages/petsc/install"
if [ -d "$PETSC_DIR" ]; then
	export PETSC_DIR
	export PETSC_ROOT=$PETSC_DIR
  export LAPACK_ROOT=$PETSC_DIR
  export SCALAPACK_ROOT=$PETSC_DIR
	ld_library_path_append "${PETSC_DIR}/lib"
fi

LAPACK_DIR="${ISSM_DIR}/externalpackages/lapack/install"
ld_library_path_append "${LAPACK_DIR}/lib"

SCOTCH_DIR="${ISSM_DIR}/externalpackages/scotch/install"
ld_library_path_append "$SCOTCH_DIR/lib"

SLEPC_DIR="${ISSM_DIR}/externalpackages/slepc/install"
ld_library_path_append "$SLEPC_DIR/lib"

TAO_DIR="${ISSM_DIR}/externalpackages/tao/install"
ld_library_path_append "$TAO_DIR/lib"

DAKOTA_DIR="${ISSM_DIR}/externalpackages/dakota/install"
path_append "$DAKOTA_DIR/bin"
ld_library_path_append "$DAKOTA_DIR/lib"
dyld_library_path_prepend "$DAKOTA_DIR/lib"

DOXYGEN_DIR="${ISSM_DIR}/externalpackages/doxygen/install"
path_prepend "$DOXYGEN_DIR/bin"

AUTOTOOLS_DIR="${ISSM_DIR}/externalpackages/autotools/install"
path_prepend "$AUTOTOOLS_DIR/bin"

SDK_DIR="C:/MicrosoftVisualStudio 9.0/Microsoft Visual C++ 2008 Express Edition with SP1 - ENU"
path_append "$SDK_DIR"

SSH_DIR="${ISSM_DIR}/externalpackages/ssh"
path_append "$SSH_DIR"

VALGRIND_DIR="${ISSM_DIR}/externalpackages/valgrind/install"
path_prepend "$VALGRIND_DIR/bin"

NCO_DIR="${ISSM_DIR}/externalpackages/nco/install/bin"
path_prepend "$NCO_DIR/bin"

CPPCHECK_DIR="${ISSM_DIR}/externalpackages/cppcheck/install"
path_append "$CPPCHECK_DIR/bin"

MERCURIAL_DIR="${ISSM_DIR}/externalpackages/mercurial/install"
if [ -d "$MERCURIAL_DIR" ]; then
	export PYTHONPATH="$PYTHONPATH:$MERCURIAL_DIR/mercurial/pure/"
	path_append "$MERCURIAL_DIR"
fi

BOOST_DIR="${ISSM_DIR}/externalpackages/boost/install"
BOOSTROOT="${ISSM_DIR}/externalpackages/boost/install"
if [ -d "$BOOST_DIR" ]; then
	export BOOSTROOT
	export BOOST_DIR
	ld_library_path_prepend   "$BOOST_DIR/lib"
	dyld_library_path_prepend "$BOOST_DIR/lib"
	path_prepend      "$BOOST_DIR/bin"
fi

XERCESROOT="${ISSM_DIR}/externalpackages/xerces/install"
if [ -d "$XERCESROOT" ]; then
	export XERCESROOT
	export XERCESCROOT="${ISSM_DIR}/externalpackages/xerces/src"
fi


XAIFBOOSTERROOT="${ISSM_DIR}/externalpackages/xaifbooster"
XAIF_DIR="${XAIFBOOSTERROOT}/xaifBooster"
if [ -d "$XAIF_DIR" ]; then
	export XAIFBOOSTERROOT
	export XAIF_DIR
	export XAIFBOOSTER_HOME=$XAIF_DIR
	export PLATFORM="x86-Linux"
fi

ANGELROOT="${ISSM_DIR}/externalpackages/angel/angel"
if [ -d "$ANGELROOT" ]; then
	export ANGELROOT
fi

OPENANALYSISROOT="${ISSM_DIR}/externalpackages/openanalysis/install"
if [ -d "$OPENANALYSISROOT" ]; then
	export OPENANALYSISROOT
	ld_library_path_append "$OPENANALYSISROOT/lib"
fi

JVM_DIR="/usr/local/gcc/4.3.2/lib64/gcj-4.3.2-9/"
ld_library_path_append "$JVM_DIR"

BBFTP_DIR="${ISSM_DIR}/externalpackages/bbftp/install"
path_append "$BBFTP_DIR/bin"

ADIC_DIR="${ISSM_DIR}/externalpackages/adic/install"
path_append "$ADIC_DIR/bin"
ld_library_path_append "$ADIC_DIR/lib"

COLPACK_DIR="${ISSM_DIR}/externalpackages/colpack/install"
ld_library_path_append "$COLPACK_DIR/lib"

ECLIPSE_DIR="${ISSM_DIR}/externalpackages/eclipse/install"
path_append "$ECLIPSE_DIR"

APPSCAN_DIR="${ISSM_DIR}/externalpackages/appscan/install"
path_append "$APPSCAN_DIR/bin"

RATS_DIR="${ISSM_DIR}/externalpackages/rats/install"
path_append "$RATS_DIR/bin"

DYSON_DIR="${ISSM_DIR}/externalpackages/dyson/"
path_append "$DYSON_DIR"

CMAKE_DIR="${ISSM_DIR}/externalpackages/cmake/install"
path_prepend "$CMAKE_DIR/bin"

SHAPELIB_DIR="${ISSM_DIR}/externalpackages/shapelib/install"
path_append "$SHAPELIB_DIR/exec"

CCCL_DIR="${ISSM_DIR}/externalpackages/cccl/install"
path_append "$CCCL_DIR/bin"

PACKAGEMAKER_DIR="${ISSM_DIR}/externalpackages/packagemaker/install"
path_append "$PACKAGEMAKER_DIR"

#android-dev-dir
export ANDROID_DIR="${ISSM_DIR}/externalpackages/android"

export ANDROID_NDK_DIR="$ANDROID_DIR/android-ndk/install"
path_append "$ANDROID_NDK_DIR/arm-linux-android-install/bin"

export ANDROID_SDK_DIR="$ANDROID_DIR/android-sdk/install"
path_append "$ANDROID_SDK_DIR/"

GSL_DIR="${ISSM_DIR}/externalpackages/gsl/install"
ld_library_path_append "$GSL_DIR/lib"

GMAKE_DIR="${ISSM_DIR}/externalpackages/gmake/install"
path_prepend "$GMAKE_DIR/bin"

MODELE_DIR="${ISSM_DIR}/externalpackages/modelE/install"
path_append "$MODELE_DIR/src/exec"

NCVIEW_DIR="${ISSM_DIR}/externalpackages/ncview/install"
path_append "$NCVIEW_DIR"

TCLX_DIR="${ISSM_DIR}/externalpackages/tclx/install/lib/tclx8.4"
ld_library_path_append "$TCLX_DIR"

ASPELL_DIR="${ISSM_DIR}/externalpackages/aspell/install"
path_append "$ASPELL_DIR/bin"

NETCDF_DIR="${ISSM_DIR}/externalpackages/netcdf/install"
if [ -d "${NETCDF_DIR}" ]; then
	path_append "${NETCDF_DIR}/bin"
	cpath_append "${NETCDF_DIR}/include"
	library_path_append "${NETCDF_DIR}/lib"
	dyld_library_path_append "${NETCDF_DIR}/lib"
	ld_library_path_append "${NETCDF_DIR}/lib"
fi

NETCDF_CXX_DIR="${ISSM_DIR}/externalpackages/netcdf-cxx/install"
if [ -d "${NETCDF_CXX_DIR}" ]; then
	ld_library_path_append "${NETCDF_CXX_DIR}/lib"
fi

HDF5_DIR="${ISSM_DIR}/externalpackages/hdf5/install"
if [ -d "${HDF5_DIR}" ]; then
	cpath_append "${HDF5_DIR}/include"
	library_path_append "${HDF5_DIR}/lib"
	dyld_library_path_append "${HDF5_DIR}/lib"
	ld_library_path_append "${HDF5_DIR}/lib"
fi

SQLITE_DIR="${ISSM_DIR}/externalpackages/sqlite/install"
if [ -d "${SQLITE_DIR}" ]; then
	path_append "${SQLITE_DIR}/bin"
	ld_library_path_append "${SQLITE_DIR}/lib"
fi

PROJ4_DIR="${ISSM_DIR}/externalpackages/proj.4/install"
if [ -d "${PROJ4_DIR}" ]; then
	dyld_library_path_prepend "${PROJ4_DIR}/lib"
	ld_library_path_prepend "${PROJ4_DIR}/lib"
fi

PROJ_DIR="${ISSM_DIR}/externalpackages/proj/install"
if [ -d "${PROJ_DIR}" ]; then
	dyld_library_path_prepend "${PROJ_DIR}/lib"
	ld_library_path_prepend "${PROJ_DIR}/lib"
fi

GDAL_DIR="${ISSM_DIR}/externalpackages/gdal/install"
if [ -d "${GDAL_DIR}" ]; then
	path_prepend "${GDAL_DIR}/bin"
	ld_library_path_append "${GDAL_DIR}/lib"
fi

GMT_DIR="${ISSM_DIR}/externalpackages/gmt/install"
if [ -d "${GMT_DIR}" ]; then
	export GMT_DIR
	path_prepend "${GMT_DIR}/bin"
fi

GMSH_DIR="${ISSM_DIR}/externalpackages/gmsh/install"
if [ -d "${GMSH_DIR}" ]; then
	path_append "${ISSM_DIR}/externalpackages/gmsh/install"
fi

CVS_DIR="${ISSM_DIR}/externalpackages/cvs/install"
path_prepend "$CVS_DIR/bin"

APR_DIR="${ISSM_DIR}/externalpackages/apr/install"
path_append "$APR_DIR/bin"
ld_library_path_append "$APR_DIR/lib"

APR_UTIL_DIR="${ISSM_DIR}/externalpackages/apr-util/install"
path_prepend "$APR_UTIL_DIR/bin"
ld_library_path_append "$APR_UTIL_DIR/lib"

YAMS_DIR="${ISSM_DIR}/externalpackages/yams/install"
path_append "$YAMS_DIR"

SWIG_DIR="${ISSM_DIR}/externalpackages/swig/install"
path_append "$SWIG_DIR"

#AUX-CONFIG
path_append "${ISSM_DIR}/aux-config"

#INISHELL
path_append "${ISSM_DIR}/externalpackages/inishell/install"

#SHELL2JUNIT
path_append "${ISSM_DIR}/externalpackages/shell2junit/install"

#EXPAT
ld_library_path_prepend "${ISSM_DIR}/externalpackages/expat/install"
dyld_library_path_prepend "${ISSM_DIR}/externalpackages/expat/install"

#CURL
CURL_DIR="${ISSM_DIR}/externalpackages/curl/install"
if [ -d "${CURL_DIR}" ]; then
	ld_library_path_prepend "${CURL_DIR}/lib"
	dyld_library_path_prepend "${CURL_DIR}/lib"
	path_prepend "${CURL_DIR}/bin"
fi

#NEOPZ
NEOPZ_DIR="${ISSM_DIR}/externalpackages/neopz/install"
if [ -d "$NEOPZ_DIR" ]; then
	export REFPATTERNDIR="$NEOPZ_DIR/include/refpatterns"
fi

TRIANGLE_DIR="${ISSM_DIR}/externalpackages/triangle/install"
if [ -d "${TRIANGLE_DIR}" ]; then
	ld_library_path_append "${TRIANGLE_DIR}/lib"
	dyld_library_path_append "${TRIANGLE_DIR}/lib"
fi

set +e

