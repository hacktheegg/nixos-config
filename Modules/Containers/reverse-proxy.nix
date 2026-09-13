{ config, lib, ... }:

{
  options.omelette.containers.reverse-proxy = {
    enable = lib.mkEnableOption "Reverse-Proxy Container";
    cloudflared = {
      enable = lib.mkEnableOption "Cloudflared";
      token = lib.mkOption {
        type = lib.types.str;
        default = null;
        example = "/run/agenix/secret1";
        description = "Path to Token file. (REQUIRED: AGENIX)";
      };
    };
  };



  config = lib.mkIf config.omelette.containers.reverse-proxy.enable {
    containers.reverse-proxy = {
      bindMounts = {
        "/etc/os-release".isReadOnly = true;
#         "/etc/ssh/ssh_host_ed25519_key".isReadOnly = true;
      } // lib.optionalAttrs config.omelette.containers.reverse-proxy.cloudflared.enable {
        "${config.omelette.containers.reverse-proxy.cloudflared.token}" = {
          hostPath = config.omelette.containers.reverse-proxy.cloudflared.token;
          isReadOnly = true;
        };
      };

      autoStart = true;
      config = { lib, pkgs, ... }: {
        system.stateVersion = "25.11";
        systemd.services.cloudflared-tunnel = lib.mkIf config.omelette.containers.reverse-proxy.cloudflared.enable {
          description = "Cloudflare Tunnel";

          wantedBy = [ "multi-user.target" ];
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];

          serviceConfig = {
            ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token-file ${config.omelette.containers.reverse-proxy.cloudflared.token}";
            Restart = "on-failure";
            RestartSec = "5s";
          };
        };

      };
    };
  };
}
