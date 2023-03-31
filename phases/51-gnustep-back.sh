#!/bin/sh
set -eo pipefail
shopt -s inherit_errexit

cd `dirname $0`

export PROJECT=gnustep-back
export GITHUB_REPO=gnustep/libs-back
export TAG=

# load environment and prepare project
../scripts/common.bat prepare_project

cd "$SRCROOT/$PROJECT"

echo
echo "### Loading GNUstep environment"
. "$UNIX_INSTALL_PREFIX/share/GNUstep/Makefiles/GNUstep.sh"

echo
echo "### Running configure"

export FREETYPE_CFLAGS="-I/c/GNUstep/${ARCH}/${BUILD_TYPE}/include/freetype2 -I/c/GNUstep/${ARCH}/${BUILD_TYPE}/include/libpng16"
export FREETYPE_LIBS="-L/c/GNUstep/${ARCH}/${BUILD_TYPE}/lib"

./configure \
    --enable-graphics=winlib \
	--enable-server=win32 \
    --host=$TARGET \
    CFLAGS="-Wno-int-conversion"

echo
echo "### Building"
make -j`nproc`

echo
echo "### Installing"
make install