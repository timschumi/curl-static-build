#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

apt update && apt -y upgrade

apt -y install build-essential

if [ -n "$PROVISION_NEEDS_MINGW" ]; then
	apt -y install mingw-w64
fi
