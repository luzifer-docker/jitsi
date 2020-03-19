VirtualHost "{{ env `JITSI_DOMAIN` }}"
    authentication = "anonymous"

    ssl = {
        key = "/var/lib/prosody/{{ env `JITSI_DOMAIN` }}.key";
        certificate = "/var/lib/prosody/{{ env `JITSI_DOMAIN` }}.crt";
    }

    modules_enabled = {
        "bosh";
        "pubsub";
    }

    c2s_require_encryption = false

VirtualHost "auth.{{ env `JITSI_DOMAIN` }}"
    ssl = {
        key = "/var/lib/prosody/auth.{{ env `JITSI_DOMAIN` }}.key";
        certificate = "/var/lib/prosody/auth.{{ env `JITSI_DOMAIN` }}.crt";
    }

    authentication = "internal_plain"

admins = { "focus@auth.{{ env `JITSI_DOMAIN` }}" }

Component "conference.{{ env `JITSI_DOMAIN` }}" "muc"

Component "jitsi-videobridge.{{ env `JITSI_DOMAIN` }}"
    component_secret = "{{ env `JITSI_VBR_SECRET` }}"

Component "focus.{{ env `JITSI_DOMAIN` }}"
    component_secret = "{{ env `JITSI_JICOFO_SECRET` }}"
