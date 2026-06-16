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

    extraConfig = ''
      zeroconf_enabled "no"

      audio_output {
        type "pipewire"
        name "PipeWire Output"
      }
    '';
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




  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
