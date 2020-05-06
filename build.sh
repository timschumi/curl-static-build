#!/bin/bash -e

SCRIPTS_DIR="$(dirname "$0")"
export CURL_SOURCE="/home/vagrant/curl"
export ZLIB_SOURCE="/home/vagrant/zlib"
export ZLIB_OUT="/home/vagrant/zlib-build"
export OPENSSL_SOURCE="/home/vagrant/openssl"
export OPENSSL_OUT="/home/vagrant/openssl-build"

# Build zlib
$SCRIPTS_DIR/zlib-sources.sh 1.2.11

$SCRIPTS_DIR/zlib-arch.sh x64
$SCRIPTS_DIR/zlib-arch.sh x86

# Build openssl
$SCRIPTS_DIR/openssl-sources.sh 1.1.1d

$SCRIPTS_DIR/openssl-arch.sh x64
$SCRIPTS_DIR/openssl-arch.sh x86

# Build curl
$SCRIPTS_DIR/curl-sources.sh 7.69.1

$SCRIPTS_DIR/curl-arch.sh x64
$SCRIPTS_DIR/curl-arch.sh x86
