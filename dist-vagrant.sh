#!/bin/bash -e

# Ensure the machines are up
vagrant up

# Build the libraries
{
vagrant ssh x86 -c "/vagrant/build.sh linux-x86"
} &

{
vagrant ssh x64 -c "/vagrant/build.sh linux-x64"
} &

{
vagrant ssh win -c "/vagrant/build.sh windows-x86"
vagrant ssh win -c "/vagrant/build.sh windows-x64"
} &

wait

# Copy out all the files
rm -rf dist-linux
mkdir -p dist-linux

vagrant ssh x86 -c "
cp zlib-out-linux-x86/lib/libz.a /vagrant/dist-linux/libz.a
cp openssl-out-linux-x86/lib/libssl.a /vagrant/dist-linux/libssl.a
cp openssl-out-linux-x86/lib/libcrypto.a /vagrant/dist-linux/libcrypto.a
cp curl-out-linux-x86/lib/libcurl.a /vagrant/dist-linux/libcurl.a
cp curl-out-linux-x86-httponly/lib/libcurl.a /vagrant/dist-linux/libcurl-httponly.a
"

vagrant ssh x64 -c "
cp zlib-out-linux-x64/lib/libz.a /vagrant/dist-linux/libz-x64.a
cp openssl-out-linux-x64/lib64/libssl.a /vagrant/dist-linux/libssl-x64.a
cp openssl-out-linux-x64/lib64/libcrypto.a /vagrant/dist-linux/libcrypto-x64.a
cp curl-out-linux-x64/lib/libcurl.a /vagrant/dist-linux/libcurl-x64.a
cp curl-out-linux-x64-httponly/lib/libcurl.a /vagrant/dist-linux/libcurl-httponly-x64.a
"

rm -rf dist-windows
mkdir -p dist-windows

vagrant ssh win -c "
cp zlib-out-windows-x86/lib/libz.a /vagrant/dist-windows/libz.a
cp openssl-out-windows-x86/lib/libssl.a /vagrant/dist-windows/libssl.a
cp openssl-out-windows-x86/lib/libcrypto.a /vagrant/dist-windows/libcrypto.a
cp curl-out-windows-x86/lib/libcurl.a /vagrant/dist-windows/libcurl.a
cp curl-out-windows-x86-httponly/lib/libcurl.a /vagrant/dist-windows/libcurl-httponly.a

cp zlib-out-windows-x64/lib/libz.a /vagrant/dist-windows/libz-x64.a
cp openssl-out-windows-x64/lib64/libssl.a /vagrant/dist-windows/libssl-x64.a
cp openssl-out-windows-x64/lib64/libcrypto.a /vagrant/dist-windows/libcrypto-x64.a
cp curl-out-windows-x64/lib/libcurl.a /vagrant/dist-windows/libcurl-x64.a
cp curl-out-windows-x64-httponly/lib/libcurl.a /vagrant/dist-windows/libcurl-httponly-x64.a
"
