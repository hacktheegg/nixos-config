{ config, lib, ... }:

let
  cfg = config.omelette.containers.jellyfin;
  mountpoint = "/mount";
in
{
  options.omelette.containers.jellyfin = {
    enable = lib.mkEnableOption "Jellyfin Container";
    cacheDir = lib.mkOption {
      type = lib.types.str;
#       default = false;
      example = "/var/cache/jellyfin";
      description = "Directory for Jellyfin Cache.";
    };
    configDir = lib.mkOption {
      type = lib.types.str;
#       default = false;
      example = "${cfg.dataDir}/config";
      description = "Directory for Jellyfin Config.";
    };
    dataDir = lib.mkOption {
      type = lib.types.str;
#       default = false;
      example = "/var/lib/jellyfin";
      description = "Directory for Jellyfin Data.";
    };
    mounts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
#       default = false;
      example = [ "/mount/Movies" "/mnt/Shows" ];
      description = "List of Custom Mounts";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.cacheDir} 0755 root root -"
      "d ${cfg.configDir} 0755 root root -"
      "d ${cfg.dataDir} 0755 root root -"
    ];
    containers.jellyfin = {
      autoStart = true;
      bindMounts = {
        cacheDir = {
          hostPath = cfg.cacheDir;
          isReadOnly = false;
          mountPoint = "${mountpoint}/cache";
        };
        configDir = {
          hostPath = cfg.configDir;
          isReadOnly = false;
          mountPoint = "${mountpoint}/config";
        };
        dataDir = {
          hostPath = cfg.dataDir;
          isReadOnly = false;
          mountPoint = "${mountpoint}/data";
        };
      } // lib.listToAttrs (lib.imap0 (i: path: {
          name = "mount${toString i}";
          value = {
            hostPath = path;
            isReadOnly = true;
            mountPoint = path;
          };
        }) cfg.mounts);

      config = { ... }: {
        system.stateVersion = "25.11";
        services.jellyfin = {
          enable = true;
          cacheDir = "${mountpoint}/cache";
          configDir = "${mountpoint}/config";
          dataDir = "${mountpoint}/data";
          openFirewall = true;
        };
      };
    };
    networking.firewall.allowedTCPPorts = [ 8080 8096 ];
  };
}
