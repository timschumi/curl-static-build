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
configure_args+=("--with-ssl=$OPENSSL_OUT-$1" "--with-zlib=$ZLIB_OUT-$1")

# Setup compiler
[[ "$1" = "linux-"* ]] && export CC="gcc"
[[ "$1" = "linux-"* ]] && export CXX="g++"

[[ "$1" = *"-x86" ]] && export CC="${CC} -m32"
[[ "$1" = *"-x86" ]] && export CXX="${CXX} -m32"

rm -rf "$BUILD_DIR"
rm -rf "$OUT_DIR"

mkdir -p $BUILD_DIR
cd "$BUILD_DIR"

$CURL_SOURCE/configure \
	--disable-shared \
        --prefix="$OUT_DIR" \
	${configure_args[@]}

make -j2
make install
