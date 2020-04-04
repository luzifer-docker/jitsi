#!/bin/bash
set -euxo pipefail

packages_build=(
	curl
	gnupg
)

packages_install=(
	jitsi-meet
	patch
	rsync
)

no_postinst_pkgs=(
	jitsi-meet-prosody    # Executes some certificate generator on wrong hostname
	jitsi-meet-web-config # Executes another cert generator
)

# Install packages required for build
apt-get update
apt-get install -yq "${packages_build[@]}"

# Add Jitsi install repo
echo "deb https://download.jitsi.org stable/" >>/etc/apt/sources.list.d/jitsi.list
curl -sSfL "https://download.jitsi.org/jitsi-key.gpg.key" | apt-key add -
apt-get update

# Install jitsi-meet without triggering postinst which breaks in Docker build
pushd /tmp
for pkg in "${no_postinst_pkgs[@]}"; do
	# Get and unpack package
	apt-get download ${pkg}
	dpkg --unpack ${pkg}*.deb

	# Remove postinst file in case it exists
	rm -f /var/lib/dpkg/info/${pkg}.postinst

	# Install package
	dpkg --configure ${pkg} || apt-get install -yqf #To fix dependencies
done
popd

apt-get install -yq "${packages_install[@]}"

# Install korvike in the container
curl -sSfL "https://github.com/Luzifer/korvike/releases/download/${KORVIKE_VERSION}/korvike_linux_amd64.tar.gz" |
	tar -xzf - -C /usr/local/bin
mv /usr/local/bin/korvike_linux_amd64 /usr/local/bin/korvike

# Install gosu
curl -sSfLo /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64"
chmod 0755 /usr/local/bin/gosu

# Install S6 overlay
curl -sSfL "https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-amd64.tar.gz" |
	tar -xzf - -C /

# Cleanup
apt-get remove -yq --purge "${packages_build[@]}"
apt-get autoremove -yq --purge
apt-get clean
rm -rf /var/lib/apt/lists/* || true
