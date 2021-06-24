#!/bin/bash -e

if [ -z "$CURL_SOURCE" ]; then
    echo "Source has not been set! Exiting..."
    exit 1
fi

if [ -f "$CURL_SOURCE/.git/BISECT_LOG" ]; then
    cd "$CURL_SOURCE"
    echo "Skipping git checkout to revision $1 due to active bisect."
elif [ -d "$CURL_SOURCE" -a -d "$CURL_SOURCE/.git" ]; then
    cd "$CURL_SOURCE"
    git fetch origin $1 && git checkout $1
else
    mkdir -p "$CURL_SOURCE"
    git clone https://github.com/curl/curl "$CURL_SOURCE" -b $1
    cd "$CURL_SOURCE"
fi

git clean -fdx
autoreconf -fi
