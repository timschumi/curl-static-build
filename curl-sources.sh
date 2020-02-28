#!/bin/bash -e

if [ -z "$CURL_SOURCE" ]; then
    echo "Source has not been set! Exiting..."
    exit 1
fi

if [ -d "$CURL_SOURCE" ]; then
    rm -rf "$CURL_SOURCE"
fi

if [ ! -f curl-$1.tar.gz ]; then
    wget https://curl.haxx.se/download/curl-$1.tar.gz
fi

tar -xf curl-$1.tar.gz
mv curl-$1 "$CURL_SOURCE"
