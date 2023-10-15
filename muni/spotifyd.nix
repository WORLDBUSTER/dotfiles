{
  config,
  deviceInfo,
  pkgs,
  ...
}: {
  enable = true;
  package = pkgs.spotifyd.override {
    withPulseAudio = true;
    withMpris = true;
  };
  settings = {
    global = {
      username = "314nfayodu4tyk5lynekgqre3wty";
      password_cmd = "${config.programs.password-store.package}/bin/pass spotify.com/municorn@musicaloft.com";
      device_name = "${deviceInfo.name}-spotifyd";
      device_type = "computer";
      use_keyring = false;
      use_mpris = true;
      backend = "pulseaudio";
    };
  };
}
