#!/bin/bash -e

configure_args=()

if [ -z "$SOURCE_DIR" ]; then
    echo "Source has not been set! Exiting..."
    exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Source is not present! Exiting..."
    exit 1
fi

case "$1" in
  "x64")
    BUILD_DIR="/home/vagrant/curl-build-64"
    OUT_DIR="/vagrant/build-64"
    ;;
  "x86")
    BUILD_DIR="/home/vagrant/curl-build-32"
    OUT_DIR="/vagrant/build-32"
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

$SOURCE_DIR/configure \
	--disable-shared \
	${configure_args[@]}

make -j2
make test
make DESTDIR="$BUILD_DIR/target" install

rm -rf "$OUT_DIR"
cp -r "$BUILD_DIR/target/usr/local/lib" "$OUT_DIR"
