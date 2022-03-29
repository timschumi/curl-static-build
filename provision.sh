#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

apt update && apt -y upgrade

apt -y install build-essential wget lsb-release pkg-config ca-certificates

if [ -n "$PROVISION_NEEDS_MINGW" ]; then
	apt -y install mingw-w64
fi

# Disable DST Root CA X3 if present
sed -i -e '/DST_Root_CA_X3/s/^!*/!/g' /etc/ca-certificates.conf
update-ca-certificates

# Create vagrant user if necessary
if ! id -u vagrant; then
	useradd -s /bin/bash -m vagrant
fi
