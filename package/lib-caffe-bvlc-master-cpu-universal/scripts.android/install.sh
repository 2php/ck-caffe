#! /bin/bash

#
# Installation script for Caffe.
#
# See CK LICENSE for licensing details.
# See CK COPYRIGHT for copyright details.
#
# Developer(s):
# - Grigori Fursin, 2015;
# - Anton Lokhmotov, 2016.
#

# PACKAGE_DIR
# INSTALL_DIR

echo "**************************************************************"
echo "Preparing vars for Caffe ..."

CK_OPENMP="-fopenmp"
if [ "${CK_HAS_OPENMP}" = "0"  ]; then
  CK_OPENMP=""
fi

# Check extra stuff
EXTRA_FLAGS=""

if [ "${CK_CPU_ARM_NEON}" == "ON" ] ; then
  EXTRA_FLAGS="$EXTRA_FLAGS -mfpu=neon"
fi

if [ "${CK_CPU_ARM_VFPV3}" == "ON" ] ; then
  EXTRA_FLAGS="$EXTRA_FLAGS -mfpu=vfpv3"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  HOST_OS="Darwin"
else
  HOST_OS="Linux"
fi

cd ${INSTALL_DIR}/obj

cmake -DCMAKE_BUILD_TYPE=${CK_ENV_CMAKE_BUILD_TYPE:-Release} \
      -DCMAKE_C_COMPILER="${CK_CC_PATH_FOR_CMAKE}" \
      -DCMAKE_C_FLAGS="${CK_CC_FLAGS_FOR_CMAKE} ${CK_CC_FLAGS_ANDROID_TYPICAL} ${EXTRA_FLAGS}" \
      -DCMAKE_CXX_COMPILER="${CK_CXX_PATH_FOR_CMAKE}" \
      -DCMAKE_CXX_FLAGS="${CK_CXX_FLAGS_FOR_CMAKE} ${CK_CXX_FLAGS_ANDROID_TYPICAL} ${EXTRA_FLAGS} -I${CK_ENV_LIB_OPENCV_INCLUDE}" \
      -DCMAKE_AR="${CK_AR_PATH_FOR_CMAKE}" \
      -DCMAKE_LINKER="${CK_LD_PATH_FOR_CMAKE}" \
      -DCMAKE_EXE_LINKER_FLAGS="${CK_LINKER_FLAGS_ANDROID_TYPICAL}" \
      -DCMAKE_EXE_LINKER_LIBS="${CK_LINKER_LIBS_ANDROID_TYPICAL}" \
      -DCMAKE_SHARED_LINKER_FLAGS="$CK_OPENMP" \
      -DANDROID=ON \
      -DBUILD_python=OFF \
      -DBUILD_docs=OFF \
      -DCPU_ONLY=ON \
      -DUSE_OPENMP:BOOL=${USE_OPENMP} \
      -DUSE_GREENTEA=OFF \
      -DUSE_LMDB=OFF \
      -DUSE_LEVELDB=OFF \
      -DUSE_HDF5=OFF \
      -DBLAS=open \
      -DBoost_ADDITIONAL_VERSIONS="1.62" \
      -DBoost_NO_SYSTEM_PATHS=ON \
      -DBOOST_ROOT=${CK_ENV_LIB_BOOST} \
      -DBOOST_INCLUDEDIR="${CK_ENV_LIB_BOOST_INCLUDE}" \
      -DBOOST_LIBRARYDIR="${CK_ENV_LIB_BOOST_LIB}" \
      -DBoost_INCLUDE_DIR="${CK_ENV_LIB_BOOST_INCLUDE}" \
      -DBoost_LIBRARY_DIR="${CK_ENV_LIB_BOOST_LIB}" \
      -DGFLAGS_INCLUDE_DIR="${CK_ENV_LIB_GFLAGS_INCLUDE}" \
      -DGFLAGS_LIBRARY="${CK_ENV_LIB_GFLAGS_LIB}/libgflags.a" \
      -DGLOG_INCLUDE_DIR="${CK_ENV_LIB_GLOG_INCLUDE}" \
      -DGLOG_LIBRARY="${CK_ENV_LIB_GLOG_LIB}/libglog.a" \
      -DOpenBLAS_INCLUDE_DIR="${CK_ENV_LIB_OPENBLAS_INCLUDE}" \
      -DOpenBLAS_LIB="${CK_ENV_LIB_OPENBLAS_LIB}/libopenblas.a" \
      -DLMDB_INCLUDE_DIR="${CK_ENV_LIB_LMDB_INCLUDE}" \
      -DLMDB_LIBRARIES="${CK_ENV_LIB_LMDB_LIB}/liblmdb.a" \
      -DOpenCV_DIR="${CK_ENV_LIB_OPENCV_JNI}" \
      -DPROTOBUF_INCLUDE_DIR="${CK_ENV_LIB_PROTOBUF_INCLUDE}" \
      -DPROTOBUF_LIBRARY="${CK_ENV_LIB_PROTOBUF_LIB}/libprotobuf.a" \
      -DPROTOBUF_PROTOC_EXECUTABLE="${CK_ENV_LIB_PROTOBUF_HOST}/bin/protoc" \
      -DBoost_USE_STATIC_LIBS=ON \
      -DANDROID_NATIVE_API_LEVEL=${CK_ANDROID_API_LEVEL} \
      -DANDROID_NDK_ABI_NAME="${CK_ANDROID_ABI}" \
      -DANDROID=ON \
      -DANDROID_NATIVE_API_LEVEL=${CK_ANDROID_API_LEVEL} \
      -DANDROID_NDK_ABI_NAME=${CK_ANDROID_ABI} \
      -DCMAKE_HOST_SYSTEM_NAME="${HOST_OS}" \
      -DCMAKE_SYSROOT="${CK_SYS_ROOT}" \
      -DCMAKE_ANDROID_API=${CK_ANDROID_API_LEVEL} \
      -DCMAKE_ANDROID_ARCH_ABI=${CK_ANDROID_ABI} \
      -DCMAKE_SYSTEM="${CK_ANDROID_NDK_PLATFORM}" \
      -DCMAKE_SYSTEM_NAME="Android" \
      -DCMAKE_SYSTEM_PROCESSOR="${CK_CMAKE_SYSTEM_PROCESSOR}" \
      -DCMAKE_CROSSCOMPILING="TRUE" \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/install" \
      ../src

if [ "${?}" != "0" ] ; then
  echo "Error: cmake failed!"
  exit 1
fi

export CK_MAKE_EXTRA="VERBOSE=1"

export PACKAGE_BUILD_TYPE=skip

return 0
