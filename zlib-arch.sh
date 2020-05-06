#!/bin/bash -e

if [ -z "$ZLIB_SOURCE" ]; then
    echo "ZLIB_SOURCE has not been set! Exiting..."
    exit 1
fi

if [ ! -d "$ZLIB_SOURCE" ]; then
    echo "ZLIB_SOURCE is not present! Exiting..."
    exit 1
fi

if [ -z "$ZLIB_OUT" ]; then
    echo "ZLIB_OUT has not been set! Exiting..."
    exit 1
fi

case "$1" in
  "x64")
    BUILD_DIR="$ZLIB_OUT-64"
    OUT_DIR="/vagrant/zlib-build-64"
    ;;
  "x86")
    BUILD_DIR="$ZLIB_OUT-32"
    OUT_DIR="/vagrant/zlib-build-32"
    export CC="gcc -m32"
    export CXX="g++ -m32"
    export PKG_CONFIG_PATH="/usr/lib32/pkgconfig"
    ;;
  *)
    echo "Unrecognized architecture: '$1'"
    exit 1
    ;;
esac

if [ -d "$BUILD_DIR" ]; then
    rm -rf "$BUILD_DIR"
fi

mkdir -p $BUILD_DIR
cd "$BUILD_DIR"

$ZLIB_SOURCE/configure

make -j2
make DESTDIR="$BUILD_DIR/target" install

rm -rf "$OUT_DIR"
cp -r "$BUILD_DIR/target/usr/local/lib" "$OUT_DIR"
