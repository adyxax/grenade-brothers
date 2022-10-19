#!/usr/bin/env bash
set -euo pipefail

zig build -Drelease-small=true

ret=0; buildah images adyxax/alpine &>/dev/null || ret=$?
if [[ "${ret}" != 0 ]]; then
	buildah rmi --all
	ALPINE_LATEST=$(curl --silent https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/x86_64/ |
		perl -lane '$latest = $1 if $_ =~ /^<a href="(alpine-minirootfs-\d+\.\d+\.\d+-x86_64\.tar\.gz)">/; END {print $latest}'
	)
	if [ ! -e "./${ALPINE_LATEST}" ]; then
		echo "Fetching ${ALPINE_LATEST}..."
		curl --silent "https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/x86_64/${ALPINE_LATEST}" \
			--output "./${ALPINE_LATEST}"
	fi

	ctr=$(buildah from scratch)
	buildah add "${ctr}" "${ALPINE_LATEST}" /
	buildah run "${ctr}" /bin/sh -c 'apk upgrade --no-cache'
	buildah run "${ctr}" /bin/sh -c 'apk add --no-cache pcre sqlite-libs'
	buildah commit "${ctr}" adyxax/alpine
	buildah rm "${ctr}"
fi

ret=0; buildah images adyxax/wasm4 &>/dev/null || ret=$?
if [[ "${ret}" != 0 ]]; then
	wasm4=$(buildah from adyxax/alpine)
	buildah run "${wasm4}" /bin/sh -c 'apk add --no-cache nodejs-current npm'
	buildah run "${wasm4}" /bin/sh -c 'npm install -g wasm4'
	buildah commit "${wasm4}" adyxax/wasm4
else
	wasm4=$(buildah from adyxax/wasm4)
fi

buildah copy "${wasm4}" zig-out/lib/cart.wasm /

buildah config \
	--author 'Julien Dessaux' \
	--cmd "w4 run --port 80 --no-open --no-qr /cart.wasm" \
	--port 80 \
	"${wasm4}"

buildah commit "${wasm4}" adyxax/grenade-brothers
buildah rm "${wasm4}"
