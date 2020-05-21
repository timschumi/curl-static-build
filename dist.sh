#!/bin/bash -e

# Ensure the machines are up
vagrant up

# Build the libraries
vagrant ssh x86 -c "/vagrant/build.sh linux-x86"
vagrant ssh x64 -c "/vagrant/build.sh linux-x64"

# Copy out all the files
rm -rf dist-linux
mkdir -p dist-linux

cp zlib-linux-x86/libz.a         dist-linux/libz.a
cp openssl-linux-x86/libssl.a    dist-linux/libssl.a
cp openssl-linux-x86/libcrypto.a dist-linux/libcrypto.a
cp curl-linux-x86/libcurl.a      dist-linux/libcurl.a

cp zlib-linux-x64/libz.a         dist-linux/libz-x64.a
cp openssl-linux-x64/libssl.a    dist-linux/libssl-x64.a
cp openssl-linux-x64/libcrypto.a dist-linux/libcrypto-x64.a
cp curl-linux-x64/libcurl.a      dist-linux/libcurl-x64.a
