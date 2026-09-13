{ config, lib, ... }:

{
  options.omelette.networks.bridges = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          example = "group-A";
          description = "Linux bridge interface name."; # TODO
        };
        gateway = lib.mkOption {
          type = lib.types.str;
          description = "Gateway address for the bridge."; # TODO
        };
#         subnet = lib.mkOption {
#           type = lib.types.str;
#           description = "Subnet assigned to the bridge."; # TODO
#         };
      };
    });
    default = {};
  };


  config = {
    networking.nat = {
      enable = true;
      internalInterfaces = lib.mapAttrsToList (_: bridge: "br-${bridge.name}") config.omelette.networks.bridges;
      externalInterface = "wlp4s0";
      enableIPv6 = true;
    };
    systemd.network = {
      enable = true;
      wait-online.enable = false;
      netdevs =
        lib.mapAttrs'
          (_: bridge:
            lib.nameValuePair "20-br-${bridge.name}" {
              netdevConfig = {
                Kind = "bridge";
                Name = "br-${bridge.name}";
              };
            })
          config.omelette.networks.bridges;
      networks =
        lib.mapAttrs'
          (_: bridge:
            lib.nameValuePair "40-br-${bridge.name}" {
              matchConfig.Name = "br-${bridge.name}";
              address = [ bridge.gateway ];
            })
          config.omelette.networks.bridges;
    };
  };
}
