var config = {

  // Connection
  bosh: '//{{ env `JITSI_DOMAIN` }}/http-bind',
  hosts: {
    domain: '{{ env `JITSI_DOMAIN` }}',
    muc: 'conference.{{ env `JITSI_DOMAIN` }}',
    bridge: 'jitsi-videobridge.{{ env `JITSI_DOMAIN` }}',
  },

  // Audio
  enableNoAudioDetection: true,
  enableNoisyMicDetection: true,

  // Misc
  channelLastN: 10,

  // UI
  useNicks: false,
  enableWelcomePage: true,

  // Peer-To-Peer mode
  p2p: {
    enabled: true,
    stunServers: [
      { urls: 'stun:meet-jit-si-turnrelay.jitsi.net:443' }
    ],
    preferH264: true
  },
};
