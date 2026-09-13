{ config, lib, ... }:

let
  cfg = config.omelette.containers.media;
  mountpoint = "/mount";
in
{
  options.omelette.containers.media = {
    enable = lib.mkEnableOption "Media Container";
    sonarr = {
    enable = lib.mkEnableOption "Sonarr";
      dataDir = lib.mkOption {
        type = lib.types.str;
  #       default = false;
        example = "/var/lib/sonarr/.config/NzbDrone";
        description = "Directory for Sonarr Data.";
      };
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
      "d ${cfg.dataDir} 0755 root root -"
    ];
    containers.media = {
      autoStart = true;
      bindMounts = {
        dataDir = {
          hostPath = cfg.dataDir;
          isReadOnly = false;
          mountPoint = "${mountpoint}/data";
        };
      } // lib.listToAttrs (lib.imap0 (i: path: {
          name = "mount${toString i}";
          value = {
            hostPath = path;
            isReadOnly = false;
            mountPoint = path;
          };
        }) cfg.mounts);

      config = { ... }: {
        system.stateVersion = "25.11";
        services.sonarr = lib.mkIf cfg.sonarr.enable {
          enable = true;
          dataDir = "${mountpoint}/data";
          openFirewall = true;
        };
      };
    };
    networking.firewall.allowedTCPPorts = [ 8989 ];
  };
}
