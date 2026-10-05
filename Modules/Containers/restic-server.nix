{ config, lib, ... }:

let
  cfg = config.omelette.containers.restic-server;
  mountpoint = "/mount";
in
{
  options.omelette.containers.restic-server = {
    enable = lib.mkEnableOption "Restic Server Container";
    dataDir = lib.mkOption {
      type = lib.types.str;
      #       default = false;
      example = "/var/lib/restic";
      description = "Restic Server Data Directory";
    };
    port = lib.mkOption {
      type = lib.types.addCheck lib.types.int (x: x >= 0 && x <= 65535);
      default = 8080;
      example = 1284;
      description = "Web port for Qbittorrent.";
    };
    htpasswd = lib.mkOption {
      type = lib.types.str;
      default = null;
      example = "/run/agenix/secret1";
      description = "Path to htpasswd file. (REQUIRED: AGENIX)";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = lib.optionals cfg.enable [
      "d ${cfg.dataDir} 0755 root root -"
    ];
    containers.restic-server = {
      autoStart = true;
      bindMounts = {
        dataDir = lib.mkIf cfg.enable {
          hostPath = cfg.dataDir;
          isReadOnly = false;
          mountPoint = "${mountpoint}/data";
        };
        "${cfg.htpasswd}" = {
          hostPath = cfg.htpasswd;
          isReadOnly = true;
        };
      };

      config = { ... }: {
        system.stateVersion = "25.11";
        services = {
          restic.server = {
            enable = true;
            dataDir = "${mountpoint}/data";
            listenAddress = cfg.port;
            htpasswd-file = cfg.htpasswd;
          };
        };
      };
    };
    networking.firewall.allowedTCPPorts = [
      cfg.port
    ];
  };
}
