#!/bin/bash -e

SCRIPTS_DIR="$(dirname "$(readlink -f "$0")")"
WORKING_DIR="$(pwd)"

if [ "$SCRIPTS_DIR" = "$WORKING_DIR" ]; then
    echo "error: Can't build inside the scripts dir"
    exit 1
fi

if [ -z "$1" ]; then
    echo "error: No target given"
    echo "usage: $0 <target>"
    exit 1
fi

if [[ "$1" != "linux-"* ]] && [[ "$1" != "windows-"* ]]; then
    echo "error: Unknown host type in target '$1'"
    exit 1
fi

if [[ "$1" != *"-x86" ]] && [[ "$1" != *"-x64" ]]; then
    echo "error: Unknown architecture in target '$1'"
    exit 1
fi

export CURL_SOURCE="$WORKING_DIR/curl"
export CURL_BUILD="$WORKING_DIR/curl-build"
export CURL_OUT="$WORKING_DIR/curl-out"
export ZLIB_SOURCE="$WORKING_DIR/zlib"
export ZLIB_BUILD="$WORKING_DIR/zlib-build"
export ZLIB_OUT="$WORKING_DIR/zlib-out"
export OPENSSL_SOURCE="$WORKING_DIR/openssl"
export OPENSSL_BUILD="$WORKING_DIR/openssl-build"
export OPENSSL_OUT="$WORKING_DIR/openssl-out"

# Build zlib
$SCRIPTS_DIR/zlib-sources.sh 1.2.12
$SCRIPTS_DIR/zlib-arch.sh "$1"

# Build openssl
$SCRIPTS_DIR/openssl-sources.sh 3.0.5
$SCRIPTS_DIR/openssl-arch.sh "$1"

# Build curl
$SCRIPTS_DIR/curl-sources.sh 7.85.0
$SCRIPTS_DIR/curl-arch.sh "$1"
$SCRIPTS_DIR/curl-arch.sh "$1" httponly
