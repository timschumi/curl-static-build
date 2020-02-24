#!/bin/bash -e

SCRIPTS_DIR="$(dirname "$0")"
export SOURCE_DIR="/home/vagrant/curl"

$SCRIPTS_DIR/get-sources.sh 7.68.0

$SCRIPTS_DIR/build-arch.sh x64
$SCRIPTS_DIR/build-arch.sh x86
