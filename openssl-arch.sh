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

case "$1" in
  "x64")
    BUILD_DIR="$OPENSSL_BUILD-64"
    OUT_DIR="$OPENSSL_OUT-64"
    configure_args+=("enable-ec_nistp_64_gcc_128" "linux-x86_64")
    ;;
  "x86")
    BUILD_DIR="$OPENSSL_BUILD-32"
    OUT_DIR="$OPENSSL_OUT-32"
    export CC="gcc -m32"
    export CXX="g++ -m32"
    export PKG_CONFIG_PATH="/usr/lib32/pkgconfig"
    configure_args+=("linux-generic32")
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

$OPENSSL_SOURCE/Configure \
    no-shared no-tests no-ssl3-method \
    ${configure_args[@]}

make -j2 depend
make -j2
make DESTDIR="$BUILD_DIR/target" install_sw

rm -rf "$OUT_DIR"
cp -r "$BUILD_DIR/target/usr/local/lib" "$OUT_DIR"
