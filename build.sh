#!/bin/bash -e

SCRIPTS_DIR="$(dirname "$0")"
export CURL_SOURCE="/home/vagrant/curl"

$SCRIPTS_DIR/curl-sources.sh 7.68.0

$SCRIPTS_DIR/curl-arch.sh x64
$SCRIPTS_DIR/curl-arch.sh x86
