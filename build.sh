#!/bin/bash -e

SCRIPTS_DIR="$(dirname "$0")"
export CURL_SOURCE="/home/vagrant/curl"
export OPENSSL_SOURCE="/home/vagrant/openssl"
export OPENSSL_OUT="/home/vagrant/openssl-build"

# Build openssl
$SCRIPTS_DIR/openssl-sources.sh 1.1.1d

$SCRIPTS_DIR/openssl-arch.sh x64
$SCRIPTS_DIR/openssl-arch.sh x86

# Build curl
$SCRIPTS_DIR/curl-sources.sh 7.68.0

$SCRIPTS_DIR/curl-arch.sh x64
$SCRIPTS_DIR/curl-arch.sh x86
