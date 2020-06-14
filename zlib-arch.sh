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
[[ "$1" = "linux-"* ]] && export CC="gcc"
[[ "$1" = "linux-"* ]] && export CXX="g++"

[[ "$1" = *"-x86" ]] && export CC="${CC} -m32"
[[ "$1" = *"-x86" ]] && export CXX="${CXX} -m32"

[[ "$1" = "linux-"* ]] && [[ "$1" = *"-x64" ]] && export CFLAGS="-fPIC"

rm -rf "$BUILD_DIR"
rm -rf "$OUT_DIR"

mkdir -p $BUILD_DIR
cd "$BUILD_DIR"

$ZLIB_SOURCE/configure --prefix="$OUT_DIR"

make -j2
make install
