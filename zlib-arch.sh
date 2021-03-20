#!/bin/bash -e

if [ -z "$ZLIB_SOURCE" ]; then
    echo "ZLIB_SOURCE has not been set! Exiting..."
    exit 1
fi

if [ ! -d "$ZLIB_SOURCE" ]; then
    echo "ZLIB_SOURCE is not present! Exiting..."
    exit 1
fi

if [ -z "$ZLIB_BUILD" ]; then
    echo "ZLIB_BUILD has not been set! Exiting..."
    exit 1
fi

if [ -z "$ZLIB_OUT" ]; then
    echo "ZLIB_OUT has not been set! Exiting..."
    exit 1
fi

BUILD_DIR="$ZLIB_BUILD-$1"
OUT_DIR="$ZLIB_OUT-$1"

# Setup compiler
[[ "$1" = *"-x86" ]] && CCPREFIX="i686"
[[ "$1" = *"-x64" ]] && CCPREFIX="x86_64"

# Debian 8 and older only had gcc for i586
[[ "$1" = "linux-x86" ]] && [[ "$(lsb_release -c -s)" = "jessie" ]] && CCPREFIX="i586"

[[ "$1" = "linux-"* ]] && CCPREFIX="${CCPREFIX}-linux-gnu"
[[ "$1" = "windows-"* ]] && CCPREFIX="${CCPREFIX}-w64-mingw32"
export CC="${CCPREFIX}-gcc"
export CXX="${CCPREFIX}-g++"

[[ "$1" = "linux-"* ]] && [[ "$1" = *"-x64" ]] && export CFLAGS="-fPIC"

[[ "$1" = "windows-"* ]] && MAKEFLAGS="-f win32/Makefile.gcc"
[[ "$1" = "windows-"* ]] && MAKEFLAGS="${MAKEFLAGS} CC=${CC}"
[[ "$1" = "windows-"* ]] && MAKEFLAGS="${MAKEFLAGS} AR=${CCPREFIX}-ar"
[[ "$1" = "windows-"* ]] && MAKEFLAGS="${MAKEFLAGS} STRIP=${CCPREFIX}-strip"
[[ "$1" = "windows-"* ]] && MAKEFLAGS="${MAKEFLAGS} RC=${CCPREFIX}-windres"
[[ "$1" = "windows-"* ]] && MAKEFLAGS="${MAKEFLAGS} INCLUDE_PATH=${OUT_DIR}/include"
[[ "$1" = "windows-"* ]] && MAKEFLAGS="${MAKEFLAGS} LIBRARY_PATH=${OUT_DIR}/lib"
[[ "$1" = "windows-"* ]] && MAKEFLAGS="${MAKEFLAGS} BINARY_PATH=${OUT_DIR}/bin"

rm -rf "$BUILD_DIR"
rm -rf "$OUT_DIR"

if [[ "$1" = "windows-"* ]]; then
    cp -r "$ZLIB_SOURCE" "$BUILD_DIR"
    cd "$BUILD_DIR"
else
    mkdir -p $BUILD_DIR
    cd "$BUILD_DIR"
    $ZLIB_SOURCE/configure --prefix="$OUT_DIR"
fi

make ${MAKEFLAGS} -j2
make ${MAKEFLAGS} install
