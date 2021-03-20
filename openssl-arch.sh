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
[[ "$1" = *"-x86" ]] && CCPREFIX="i686"
[[ "$1" = *"-x64" ]] && CCPREFIX="x86_64"

# Debian 8 and older only had gcc for i586
[[ "$1" = "linux-x86" ]] && [[ "$(lsb_release -c -s)" = "jessie" ]] && CCPREFIX="i586"

[[ "$1" = "linux-"* ]] && CCPREFIX="${CCPREFIX}-linux-gnu"
[[ "$1" = "windows-"* ]] && CCPREFIX="${CCPREFIX}-w64-mingw32"
configure_args+="--cross-compile-prefix=${CCPREFIX}-"

# Enable magic optimzation for x64
[[ "$1" = *"-x64" ]] && configure_args+=("enable-ec_nistp_64_gcc_128")

# Set the target
if [[ "$1" = "linux-"* ]]; then
    [[ "$1" = *"-x86" ]] && configure_args+=("linux-x86")
    [[ "$1" = *"-x64" ]] && configure_args+=("linux-x86_64")
fi
if [[ "$1" = "windows-"* ]]; then
    [[ "$1" = *"-x86" ]] && configure_args+=("mingw")
    [[ "$1" = *"-x64" ]] && configure_args+=("mingw64")
fi

rm -rf "$BUILD_DIR"
rm -rf "$OUT_DIR"

mkdir -p $BUILD_DIR
cd "$BUILD_DIR"

$OPENSSL_SOURCE/Configure \
    no-shared no-tests no-ssl3-method \
    --prefix="$OUT_DIR" --openssldir="$OUT_DIR" \
    ${configure_args[@]}

make -j2 depend
make -j2
make install_sw
