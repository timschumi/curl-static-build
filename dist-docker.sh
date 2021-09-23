#!/bin/bash -e

# Ensure the machines are up
if ! docker start curl_static_x86; then
    docker run --name curl_static_x86 -td -v .:/vagrant --platform=linux/386 docker.io/debian:8
    docker exec curl_static_x86 /vagrant/vagrant-provision.sh
fi

if ! docker start curl_static_x64; then
    docker run --name curl_static_x64 -td -v .:/vagrant --platform=linux/amd64 docker.io/debian:8
    docker exec curl_static_x64 /vagrant/vagrant-provision.sh
fi

if ! docker start curl_static_win; then
    docker run --name curl_static_win -td -v .:/vagrant docker.io/debian:10
    docker exec -e PROVISION_NEEDS_MINGW=1 curl_static_win /vagrant/vagrant-provision.sh
fi

# Build the libraries
{
docker exec -u vagrant -w /home/vagrant curl_static_x86 /vagrant/build.sh linux-x86
} &

{
docker exec -u vagrant -w /home/vagrant curl_static_x64 /vagrant/build.sh linux-x64
} &

{
docker exec -u vagrant -w /home/vagrant curl_static_win /vagrant/build.sh windows-x86
docker exec -u vagrant -w /home/vagrant curl_static_win /vagrant/build.sh windows-x64
} &

wait

# Copy out all the files
rm -rf dist-linux
mkdir -p dist-linux

docker cp curl_static_x86:/home/vagrant/zlib-out-linux-x86/lib/libz.a dist-linux/libz.a
docker cp curl_static_x86:/home/vagrant/openssl-out-linux-x86/lib/libssl.a dist-linux/libssl.a
docker cp curl_static_x86:/home/vagrant/openssl-out-linux-x86/lib/libcrypto.a dist-linux/libcrypto.a
docker cp curl_static_x86:/home/vagrant/curl-out-linux-x86/lib/libcurl.a dist-linux/libcurl.a
docker cp curl_static_x86:/home/vagrant/curl-out-linux-x86-httponly/lib/libcurl.a dist-linux/libcurl-httponly.a

docker cp curl_static_x64:/home/vagrant/zlib-out-linux-x64/lib/libz.a dist-linux/libz-x64.a
docker cp curl_static_x64:/home/vagrant/openssl-out-linux-x64/lib64/libssl.a dist-linux/libssl-x64.a
docker cp curl_static_x64:/home/vagrant/openssl-out-linux-x64/lib64/libcrypto.a dist-linux/libcrypto-x64.a
docker cp curl_static_x64:/home/vagrant/curl-out-linux-x64/lib/libcurl.a dist-linux/libcurl-x64.a
docker cp curl_static_x64:/home/vagrant/curl-out-linux-x64-httponly/lib/libcurl.a dist-linux/libcurl-httponly-x64.a

rm -rf dist-windows
mkdir -p dist-windows

docker cp curl_static_win:/home/vagrant/zlib-out-windows-x86/lib/libz.a dist-windows/libz.a
docker cp curl_static_win:/home/vagrant/openssl-out-windows-x86/lib/libssl.a dist-windows/libssl.a
docker cp curl_static_win:/home/vagrant/openssl-out-windows-x86/lib/libcrypto.a dist-windows/libcrypto.a
docker cp curl_static_win:/home/vagrant/curl-out-windows-x86/lib/libcurl.a dist-windows/libcurl.a
docker cp curl_static_win:/home/vagrant/curl-out-windows-x86-httponly/lib/libcurl.a dist-windows/libcurl-httponly.a

docker cp curl_static_win:/home/vagrant/zlib-out-windows-x64/lib/libz.a dist-windows/libz-x64.a
docker cp curl_static_win:/home/vagrant/openssl-out-windows-x64/lib64/libssl.a dist-windows/libssl-x64.a
docker cp curl_static_win:/home/vagrant/openssl-out-windows-x64/lib64/libcrypto.a dist-windows/libcrypto-x64.a
docker cp curl_static_win:/home/vagrant/curl-out-windows-x64/lib/libcurl.a dist-windows/libcurl-x64.a
docker cp curl_static_win:/home/vagrant/curl-out-windows-x64-httponly/lib/libcurl.a dist-windows/libcurl-httponly-x64.a
