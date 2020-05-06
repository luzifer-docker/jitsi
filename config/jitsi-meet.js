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

  // Video: Allow cams with more than 720p
  constraints: {
    video: {
      height: {
        ideal: 720,
        max: 1080,
        min: 240
      }
    }
  },

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
