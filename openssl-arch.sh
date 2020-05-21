#!/bin/bash -e

configure_args=()

if [ -z "$OPENSSL_SOURCE" ]; then
    echo "OPENSSL_SOURCE has not been set! Exiting..."
    exit 1
fi

if [ ! -d "$OPENSSL_SOURCE" ]; then
    echo "OPENSSL_SOURCE is not present! Exiting..."
    exit 1
fi

if [ -z "$OPENSSL_BUILD" ]; then
    echo "OPENSSL_BUILD has not been set! Exiting..."
    exit 1
fi

if [ -z "$OPENSSL_OUT" ]; then
    echo "OPENSSL_OUT has not been set! Exiting..."
    exit 1
fi

rm -rf "$OPENSSL_BUILD"

BUILD_DIR="$OPENSSL_BUILD-$1"
OUT_DIR="$OPENSSL_OUT-$1"

# Setup compiler
[[ "$1" = "linux-"* ]] && export CC="gcc"
[[ "$1" = "linux-"* ]] && export CXX="g++"

# Enable magic optimzation for x64
[[ "$1" = *"-x64" ]] && configure_args+=("enable-ec_nistp_64_gcc_128")

# Set the target
if [[ "$1" = "linux-"* ]]; then
    [[ "$1" = *"-x86" ]] && configure_args+=("linux-x86")
    [[ "$1" = *"-x64" ]] && configure_args+=("linux-x86_64")
fi

if [ -d "$BUILD_DIR" ]; then
    rm -rf "$BUILD_DIR"
fi

mkdir -p $BUILD_DIR
cd "$BUILD_DIR"

$OPENSSL_SOURCE/Configure \
    no-shared no-tests no-ssl3-method \
    ${configure_args[@]}

make -j2 depend
make -j2
make DESTDIR="$BUILD_DIR/target" install_sw

rm -rf "$OUT_DIR"
cp -r "$BUILD_DIR/target/usr/local/lib" "$OUT_DIR"
