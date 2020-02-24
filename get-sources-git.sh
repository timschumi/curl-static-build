#!/bin/bash -e

if [ -z "$SOURCE_DIR" ]; then
    echo "Source has not been set! Exiting..."
    exit 1
fi

if [ -d "$SOURCE_DIR" -a -d "$SOURCE_DIR/.git" ]; then
    cd "$SOURCE_DIR"
    git fetch origin $1 && git checkout $1
else
    mkdir -p "$SOURCE_DIR"
    git clone https://github.com/curl/curl "$SOURCE_DIR" -b $1
    cd "$SOURCE_DIR"
fi

git clean -fdx
./buildconf
