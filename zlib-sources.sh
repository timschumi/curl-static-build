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

# CVE-2022-37434
curl -L "https://github.com/madler/zlib/commit/eff308af425b67093bab25f80f1ae950166bece1.patch" | patch -p1 -d zlib-$1
curl -L "https://github.com/madler/zlib/commit/1eb7682f845ac9e9bf9ae35bbfb3bad5dacbd91d.patch" | patch -p1 -d zlib-$1

mv zlib-$1 "$ZLIB_SOURCE"
