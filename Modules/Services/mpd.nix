{ config, lib, ... }:

let
  cfg = config.omelette.services.mpd;
#   mountpoint = "/mount";
in
{
  options.omelette.services.mpd = {
    enable = lib.mkEnableOption "MPD Service";
    dataDir = lib.mkOption {
      type = lib.types.str;
      #       default = false;
      example = "/var/lib/mpd";
      description = "MPD Profile Directory";
    };
    musicDir = lib.mkOption {
      type = lib.types.str;
      #       default = false;
      example = "/home/user/Music";
      description = "Saved Music Directory";
    };
    port = lib.mkOption {
      type = lib.types.addCheck lib.types.int (x: x >= 0 && x <= 65535);
      default = 2859;
      example = 1284;
      description = "Connection port for MPD.";
    };
    streamPort = lib.mkOption {
      type = lib.types.addCheck lib.types.int (x: x >= 0 && x <= 65535);
      default = 6942;
      example = 1284;
      description = "Streaming port for HTTP stream.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = lib.optionals cfg.enable [
      "d ${cfg.dataDir} 0755 mpd mpd -"
    ];
    services.mpd = {
      enable = true;
      settings = {
        audio_output = [ {
          type = "httpd";
          name = "MPD FLAC Stream";
          encoder = "flac";
          port = "${ toString cfg.streamPort }";
          format = "96000:24:2";
          always_on = "yes";
          tags = "yes";
        } ];
        bind_to_address = "any";
        music_directory = cfg.musicDir;
        port = cfg.port;
      };
      dataDir = cfg.dataDir;
    };
  };
}
