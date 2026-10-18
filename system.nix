{ }:

let

  inherit (import ./channels.nix)
    nixpkgs
    agenix
    copyparty
    preservation
    comin
    ;
  # nixpkgs = builtins.fetchTarball

  hostConfigs = import ./hosts.nix;

  #
  # I hate having to do this
  #
  mkSystem =
    selectedHost:
    import "${nixpkgs}/nixos" {
      configuration = {
        imports = [
          "${agenix}/modules/age.nix"
          "${copyparty}/contrib/nixos/modules/copyparty.nix"
          "${preservation}/module.nix"
          (import "${comin}/nix/module.nix" {
            self = {
              packages = {};
            };
          })
          #           ./Pkgs
          ./configuration.nix
          (builtins.getAttr selectedHost hostConfigs)
        ];

        # makes the program's package accessible within configuration
        nixpkgs.overlays = [
          (final: prev: {
            comin = prev.callPackage "${comin}/nix/package.nix" {};
          })

          (import "${copyparty}/contrib/package/nix/overlay.nix")
        ];

        nix.nixPath = [
          "nixpkgs=${nixpkgs}"
        ];
      };

      specialArgs = {
        inherit agenix;
      };

    };

in
{
  Thinkpad-T460 = mkSystem "Thinkpad-T460";
  IdeaPad-L3 = mkSystem "IdeaPad-L3";
  Pavilion-dv7-Notebook = mkSystem "Pavilion-dv7-Notebook";
  HP-Compaq = mkSystem "HP-Compaq";
}
