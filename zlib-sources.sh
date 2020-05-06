#!/bin/bash -e

if [ -z "$ZLIB_SOURCE" ]; then
    echo "Source has not been set! Exiting..."
    exit 1
fi

if [ -d "$ZLIB_SOURCE" ]; then
    rm -rf "$ZLIB_SOURCE"
fi

if [ ! -f zlib-$1.tar.gz ]; then
    wget https://www.zlib.net/zlib-$1.tar.gz
fi

tar -xf zlib-$1.tar.gz
mv zlib-$1 "$ZLIB_SOURCE"
