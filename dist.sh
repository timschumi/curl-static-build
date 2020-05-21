#!/bin/bash -e

# Ensure the machines are up
vagrant up

# Build the libraries
vagrant ssh x86 -c "/vagrant/build.sh x86"
vagrant ssh x64 -c "/vagrant/build.sh x64"

# Copy out all the files
rm -rf dist
mkdir -p dist

cp zlib-x86/libz.a         dist/libz.a
cp openssl-x86/libssl.a    dist/libssl.a
cp openssl-x86/libcrypto.a dist/libcrypto.a
cp curl-x86/libcurl.a      dist/libcurl.a

cp zlib-x64/libz.a         dist/libz-x64.a
cp openssl-x64/libssl.a    dist/libssl-x64.a
cp openssl-x64/libcrypto.a dist/libcrypto-x64.a
cp curl-x64/libcurl.a      dist/libcurl-x64.a
