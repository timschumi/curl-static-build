#!/bin/bash -e

if [ -z "$OPENSSL_SOURCE" ]; then
    echo "Source has not been set! Exiting..."
    exit 1
fi

if [ -d "$OPENSSL_SOURCE" ]; then
    rm -rf "$OPENSSL_SOURCE"
fi

if [ ! -f openssl-$1.tar.gz ]; then
    wget https://www.openssl.org/source/openssl-$1.tar.gz
fi

tar -xf openssl-$1.tar.gz
mv openssl-$1 "$OPENSSL_SOURCE"
