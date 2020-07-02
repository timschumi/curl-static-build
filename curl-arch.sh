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
[[ "$1" = *"-x86" ]] && CCPREFIX="i686"
[[ "$1" = *"-x64" ]] && CCPREFIX="x86_64"
[[ "$1" = "linux-"* ]] && CCPREFIX="${CCPREFIX}-linux-gnu"
[[ "$1" = "windows-"* ]] && CCPREFIX="${CCPREFIX}-w64-mingw32"
export CC="${CCPREFIX}-gcc"
export CXX="${CCPREFIX}-g++"

if [[ "$1" = "windows-"* ]]; then
    configure_args+=("--without-ssl")
    configure_args+=("--with-winssl")
    configure_args+=("--host=${CCPREFIX}")
fi

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
