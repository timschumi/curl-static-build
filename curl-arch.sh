#!/bin/bash -e

configure_args=()

if [ -z "$CURL_SOURCE" ]; then
    echo "Source has not been set! Exiting..."
    exit 1
fi

if [ ! -d "$CURL_SOURCE" ]; then
    echo "Source is not present! Exiting..."
    exit 1
fi

BUILD_DIR="$CURL_BUILD-$1"
OUT_DIR="$CURL_OUT-$1"
configure_args+=("--with-ssl=$OPENSSL_BUILD-$1/target" "--with-zlib=$ZLIB_BUILD-$1/target")

# Setup compiler
[[ "$1" = "linux-"* ]] && export CC="gcc"
[[ "$1" = "linux-"* ]] && export CXX="g++"

[[ "$1" = *"-x86" ]] && export CC="${CC} -m32"
[[ "$1" = *"-x86" ]] && export CXX="${CXX} -m32"

if [ -d "$BUILD_DIR" ]; then
    rm -rf "$BUILD_DIR"
fi

mkdir -p $BUILD_DIR
cd "$BUILD_DIR"

$CURL_SOURCE/configure \
	--disable-shared \
	${configure_args[@]}

make -j2
make DESTDIR="$BUILD_DIR/target" install

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"
cp -r "$BUILD_DIR/target/usr/local/lib" "$OUT_DIR"
