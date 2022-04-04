#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

apt-get update && apt-get -y upgrade

apt-get -y install build-essential wget lsb-release pkg-config ca-certificates

if [ -n "$PROVISION_BINUTILS_COMPAT_LINKS" ]; then
	for i in /usr/bin/*-linux-gnu-*-${PROVISION_BINUTILS_COMPAT_LINKS}; do
		LINKNAME="$(sed "s/-${PROVISION_BINUTILS_COMPAT_LINKS}\$//g" <<< "${i}")"

		if [ -f "${LINKNAME}" ]; then
			continue
		fi

		ln -svf "${i}" "${LINKNAME}"
	done
fi

if [ -n "$PROVISION_NEEDS_MINGW" ]; then
	apt-get -y install mingw-w64
fi

# Disable DST Root CA X3 if present
sed -i -e '/DST_Root_CA_X3/s/^!*/!/g' /etc/ca-certificates.conf
update-ca-certificates

# Create vagrant user if necessary
if ! id -u vagrant; then
	mkdir -p /home
	useradd -s /bin/bash -m vagrant
fi
