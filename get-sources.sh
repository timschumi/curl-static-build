#!/bin/bash -e

if [ -z "$SOURCE_DIR" ]; then
    echo "Source has not been set! Exiting..."
    exit 1
fi

if [ -d "$SOURCE_DIR" ]; then
    rm -rf "$SOURCE_DIR"
fi

if [ ! -f curl-$1.tar.gz ]; then
    wget https://curl.haxx.se/download/curl-$1.tar.gz
fi

tar -xf curl-$1.tar.gz
mv curl-$1 "$SOURCE_DIR"
