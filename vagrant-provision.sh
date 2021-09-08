#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

apt update && apt -y upgrade

apt -y install build-essential wget lsb-release

if [ -n "$PROVISION_NEEDS_MINGW" ]; then
	apt -y install mingw-w64
fi

# Create vagrant user if necessary
if ! id -u vagrant; then
	useradd -s /bin/bash -m vagrant
fi
