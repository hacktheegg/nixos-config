{ config, lib, ... }:

let
  cfg = config.omelette.containers.media;
#   mountpoint = "/mount";
  servarrData = "/mount/servarr";
in
{
  options.omelette.containers.media = {
    enable = lib.mkEnableOption "Media Container";
    mounts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
#       default = false;
      example = [ "/mount/Movies" "/mnt/Shows" ];
      description = "List of Custom Mounts";
    };
    radarr = {
      enable = lib.mkEnableOption "Radarr";
      dataDir = lib.mkOption {
        type = lib.types.str;
  #       default = false;
        example = "/var/lib/radarr/.config/NzbDrone";
        description = "Directory for Radarr Data.";
      };
      webPort = lib.mkOption {
        type = lib.types.addCheck lib.types.int (x: x >= 0 && x <= 65535);
        default = 7878;
        example = 8080;
        description = "Web port for Radarr.";
      };
    };
    sonarr = {
      enable = lib.mkEnableOption "Sonarr";
      dataDir = lib.mkOption {
        type = lib.types.str;
  #       default = false;
        example = "/var/lib/sonarr/.config/NzbDrone";
        description = "Directory for Sonarr Data.";
      };
      webPort = lib.mkOption {
        type = lib.types.addCheck lib.types.int (x: x >= 0 && x <= 65535);
        default = 8989;
        example = 8080;
        description = "Web port for Sonarr.";
      };
    };
    lidarr = {
      enable = lib.mkEnableOption "Lidarr";
      dataDir = lib.mkOption {
        type = lib.types.str;
  #       default = false;
        example = "/var/lib/lidarr/.config/NzbDrone";
        description = "Directory for Lidarr Data.";
      };
      webPort = lib.mkOption {
        type = lib.types.addCheck lib.types.int (x: x >= 0 && x <= 65535);
        default = 8686;
        example = 8080;
        description = "Web port for Lidarr.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules =
      lib.optionals cfg.radarr.enable [
        "d ${cfg.radarr.dataDir} 0755 root root -"
      ] ++
      lib.optionals cfg.sonarr.enable [
        "d ${cfg.sonarr.dataDir} 0755 root root -"
      ] ++
      lib.optionals cfg.lidarr.enable [
        "d ${cfg.lidarr.dataDir} 0755 root root -"
      ];
    containers.media = {
      autoStart = true;
      bindMounts = {
        radarrDataDir = lib.mkIf cfg.radarr.enable {
          hostPath = cfg.radarr.dataDir;
          isReadOnly = false;
          mountPoint = "${servarrData}/radarr/data";
        };
        sonarrDataDir = lib.mkIf cfg.sonarr.enable {
          hostPath = cfg.sonarr.dataDir;
          isReadOnly = false;
          mountPoint = "${servarrData}/sonarr/data";
        };
        lidarrDataDir = lib.mkIf cfg.lidarr.enable {
          hostPath = cfg.lidarr.dataDir;
          isReadOnly = false;
          mountPoint = "${servarrData}/lidarr/data";
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
          radarr = lib.mkIf cfg.radarr.enable {
            enable = true;
            dataDir = "${servarrData}/radarr/data";
            openFirewall = true;
            settings.port = cfg.radarr.webPort;
          };
          sonarr = lib.mkIf cfg.sonarr.enable {
            enable = true;
            dataDir = "${servarrData}/sonarr/data";
            openFirewall = true;
            settings.port = cfg.sonarr.webPort;
          };
          lidarr = lib.mkIf cfg.lidarr.enable {
            enable = true;
            dataDir = "${servarrData}/lidarr/data";
            openFirewall = true;
            settings.port = cfg.lidarr.webPort;
          };
        };
      };
    };
    networking.firewall.allowedTCPPorts =
      lib.optionals cfg.radarr.enable [
        cfg.radarr.webPort
      ] ++
      lib.optionals cfg.sonarr.enable [
        cfg.sonarr.webPort
      ] ++
      lib.optionals cfg.lidarr.enable [
        cfg.lidarr.webPort
      ];
  };
}
