{ config, lib, ... }:

let
  cfg = config.omelette.networks.bridges;
in
{
  options.omelette.networks.bridges = lib.mkOption {
    enable = lib.mkEnableOption "Container Bridges";
    groups = {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            example = "br-group-A";
            description = "Linux bridge interface name."; # TODO
          };
          gateway = lib.mkOption {
            type = lib.types.str;
            description = "Gateway address for the bridge."; # TODO
          };
        };
      });
      default = {};
    };
  };

  /*
  networking.nat = {
    enable = true;
    internalInterfaces = [ "br0" ];
    externalInterface = "wlp5s0";
    enableIPv6 = true;
  };
*/

  config = lib.mkIf cfg.enable {
    networking.nat = {
      enable = true;
      internalInterfaces = lib.mapAttrsToList (_: bridge: "${bridge.name}") cfg.groups;
      externalInterface = "wlp4s0";
      enableIPv6 = true;
    };
    systemd.network = {
      enable = true;
      wait-online.enable = false;
      netdevs =
        lib.mapAttrs'
          (_: bridge:
            lib.nameValuePair "20-${bridge.name}" {
              netdevConfig = {
                Kind = "bridge";
                Name = "${bridge.name}";
              };
            })
          cfg.groups;
      networks =
        lib.mapAttrs'
          (_: bridge:
            lib.nameValuePair "40-${bridge.name}" {
              matchConfig.Name = "${bridge.name}";
              address = [ bridge.gateway ];
            })
          cfg.groups;
    };
  };
}
