#!/bin/bash -e

configure_args=()

if [ -z "$CURL_SOURCE" ]; then
    echo "Source has not been set! Exiting..."
    exit 1
fi

if [ ! -d "$CURL_SOURCE" ]; then
    echo "Source is not present! Exiting..."
    exit 1
fi

BUILD_DIR="$CURL_BUILD-$1"
OUT_DIR="$CURL_OUT-$1"
configure_args+=("--with-zlib=$ZLIB_OUT-$1" "--without-librtmp")

# Parse options
for i in "${@:2}"; do
	case "$i" in
	"httponly")
		build_httponly=1
		;;
	*)
		echo "Unknown argument: '$i'" >&2
		exit 1
	esac
done

# Setup compiler
[[ "$1" = *"-x86" ]] && CCPREFIX="i686"
[[ "$1" = *"-x64" ]] && CCPREFIX="x86_64"

# Debian 8 and older only had gcc for i586
[[ "$1" = "linux-x86" ]] && [[ "$(lsb_release -c -s)" = "jessie" ]] && CCPREFIX="i586"

[[ "$1" = "linux-"* ]] && CCPREFIX="${CCPREFIX}-linux-gnu"
[[ "$1" = "windows-"* ]] && CCPREFIX="${CCPREFIX}-w64-mingw32"
export CC="${CCPREFIX}-gcc"
export CXX="${CCPREFIX}-g++"

# Select the correct TLS backends
[[ "$1" = "linux-"* ]] && configure_args+=("--with-openssl=$OPENSSL_OUT-$1")
[[ "$1" = "windows-"* ]] && configure_args+=("--with-schannel")

if [[ "$1" = "windows-"* ]]; then
    configure_args+=("--disable-pthreads")
    configure_args+=("--host=${CCPREFIX}")
fi

# We aren't doing any cookie handling at the moment, so don't require libpsl.
# TODO: Look into supporting this properly.
configure_args+=("--without-libpsl")

# Disable everything except HTTP if requested
if [ "$build_httponly" = "1" ]; then
    BUILD_DIR+="-httponly"
    OUT_DIR+="-httponly"
    configure_args+=("--disable-ftp")
    configure_args+=("--disable-file")
    configure_args+=("--disable-ldap")
    configure_args+=("--disable-ldaps")
    configure_args+=("--disable-rtsp")
    configure_args+=("--disable-proxy")
    configure_args+=("--disable-dict")
    configure_args+=("--disable-telnet")
    configure_args+=("--disable-tftp")
    configure_args+=("--disable-pop3")
    configure_args+=("--disable-imap")
    configure_args+=("--disable-smb")
    configure_args+=("--disable-smtp")
    configure_args+=("--disable-gopher")
    configure_args+=("--disable-mqtt")
fi

rm -rf "$BUILD_DIR"
rm -rf "$OUT_DIR"

mkdir -p $BUILD_DIR
cd "$BUILD_DIR"

$CURL_SOURCE/configure \
	--disable-shared \
        --prefix="$OUT_DIR" \
	${configure_args[@]}

make -j2
make install
