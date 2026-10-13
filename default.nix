let
  systems = (import ./system.nix) {};
in
builtins.mapAttrs
  (_: system: {
    config = system.config;
    toplevel = system.config.system.build.toplevel;
  })
  systems
