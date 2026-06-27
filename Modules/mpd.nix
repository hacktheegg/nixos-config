{ config, ... }:

{

  # 1. MPD Configuration - Restricted to Localhost
  services.mpd = {
    enable = true;
    user = "hacktheegg";
    musicDirectory = "/home/hacktheegg/Music";
    playlistDirectory = "/home/hacktheegg/Music/playlists";

    # Restrict MPD to only listen for connections from this machine
    network.listenAddress = "127.0.0.1";
    network.port = 6600;

#     extraConfig = ''
#       zeroconf_enabled "no"
#
#       audio_output {
#         type "pipewire"
#         name "PipeWire Output"
#       }
#     '';
  };

  systemd.services.mpd.environment = {
    # PipeWire uses XDG_RUNTIME_DIR to find its socket.
    # 1001 is usually the UID of the first user created on NixOS.
    XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.hacktheegg.uid}";
  };

  # 2. myMPD Configuration - Restricted to Localhost
  services.mympd = {
    enable = true;
    #musicDirectory = "/home/hacktheegg/Music";
    settings = {
      # Bind the web interface to localhost only
      http_host = "127.0.0.1";
      http_port = 8081;

      # Connect to the local MPD instance
      mpd_host = "127.0.0.1";
      mpd_port = 6600;
    };
  };

  systemd.services.mympd.serviceConfig = {
    #ProtectHome = "no";
    ReadWritePaths = [ "/home/hacktheegg/Music" ];
  };

}
