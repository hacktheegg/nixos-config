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
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = lib.optionals cfg.enable [
      "d ${cfg.dataDir} 0755 mpd mpd -"
    ];
    services.mpd = {
      enable = true;
      settings = {
        bind_to_address = "any";
        music_directory = cfg.musicDir;
        port = cfg.port;
      };
      dataDir = cfg.dataDir;
    };
  };
}
