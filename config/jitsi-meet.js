var config = {
  hosts: {
    domain: '{{ env `JITSI_DOMAIN` }}',
    muc: 'conference.{{ env `JITSI_DOMAIN` }}',
    bridge: 'jitsi-videobridge.{{ env `JITSI_DOMAIN` }}',
  },
  useNicks: false,
  bosh: '//{{ env `JITSI_DOMAIN` }}/http-bind',
};
