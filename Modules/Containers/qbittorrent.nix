{ config, lib, ... }:

let
  cfg = config.omelette.containers.qbittorrent;
  mountpoint = "/mount";
in
{
  options.omelette.containers.qbittorrent = {
    enable = lib.mkEnableOption "Qbittorrent Container";
    profileDir = lib.mkOption {
      type = lib.types.str;
#       default = false;
      example = "/var/lib/qBittorrent";
      description = "Qbittorrent Profile Directory";
    };
    mounts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
#       default = false;
      example = [ "/mount/Movies" "/mnt/Shows" ];
      description = "List of Custom Mounts";
    };
    webPort = lib.mkOption {
      type = lib.types.addCheck lib.types.int (x: x >= 0 && x <= 65535);
      default = 8080;
      example = 1284;
      description = "Web port for Qbittorrent.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules =
      lib.optionals cfg.enable [
        "d ${cfg.profileDir} 0755 root root -"
      ];
    containers.qbittorrent = {
      autoStart = true;
      bindMounts = {
        profileDir = lib.mkIf cfg.enable {
          hostPath = cfg.profileDir;
          isReadOnly = false;
          mountPoint = "${mountpoint}/profile";
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
        services = {
          qbittorrent = {
            enable = true;
            profileDir = cfg.profileDir;
            openFirewall = true;
            webuiPort = cfg.webPort;
          };
        };
      };
    };
    networking.firewall.allowedTCPPorts = [
        cfg.webPort
      ];
  };
}
