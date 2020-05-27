#!/usr/bin/with-contenv /bin/bash
set -euxo pipefail

[ -e /etc/jitsi/.configured ] && {
	echo "Configuration was already applied, not re-applying"
	exit 0
}

cfg_file_path="/usr/local/share/jitsi-config"

[ -n "${JITSI_DOMAIN:-}" ] || {
	echo "Missing JITSI_DOMAIN env variable" >&2
	exit 1
}

# Generate internal passwords
export JITSI_VBR_SECRET=$(openssl rand -hex 20)
export JITSI_JICOFO_SECRET=$(openssl rand -hex 20)
export JITSI_ADMIN_SECRET=$(openssl rand -hex 20)

# Generate configuration files
korvike \
	-i "${cfg_file_path}/jitsi-meet.js" \
	-o "/etc/jitsi/meet/config.js"

korvike \
	-i "${cfg_file_path}/prosody.cfg.lua" \
	-o "/etc/prosody/conf.d/${JITSI_DOMAIN}.cfg.lua"

korvike \
	-i "${cfg_file_path}/nginx.conf" \
	-o "/etc/nginx/nginx.conf"

korvike \
	-i "${cfg_file_path}/startenv" \
	-o "/etc/jitsi-env.conf"

# Generate certificates
echo | prosodyctl cert generate "${JITSI_DOMAIN}"
echo | prosodyctl cert generate "auth.${JITSI_DOMAIN}"

# Trust generated certificate
ln -sf /var/lib/prosody/auth.${JITSI_DOMAIN}.crt /usr/local/share/ca-certificates/auth.${JITSI_DOMAIN}.crt
update-ca-certificates -f

# Generate user for admin
prosodyctl register focus "auth.${JITSI_DOMAIN}" "${JITSI_ADMIN_SECRET}"

# Overwrite UI files from mount
[ -d /ui/files ] && rsync -rv /ui/files/ /usr/share/jitsi-meet/
[ -d /ui/patches ] && {
	pushd /usr/share/jitsi-meet

	for patch_file in /ui/patches/*.patch; do
		patch -b -i "${patch_file}" -p0
	done

	popd
}

# Mark container as initialized not to overwrite config
# which would break the container as passwords would be
# re-issued
touch /etc/jitsi/.configured
