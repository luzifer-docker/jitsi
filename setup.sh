#!/usr/bin/with-contenv /bin/bash
set -euxo pipefail

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
