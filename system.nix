{}:

let

  inherit (import ./channels.nix) nixpkgs home-manager agenix copyparty nur preservation;
   # nixpkgs = builtins.fetchTarball

  hostConfigs = import ./hosts.nix;

  pkgs = import nixpkgs {
    config.allowUnfree = true;

    overlays = [
      (import "${copyparty}/contrib/package/nix/overlay.nix")
    ];
  };

  nurPkgs = import nur {
    inherit pkgs;
    nurpkgs = pkgs;
  };


  #
  # I hate having to do this
  #
  mkSystem = selectedHost:
    import "${nixpkgs}/nixos" {
      configuration = {
        imports = [
          "${home-manager}/nixos"
          "${agenix}/modules/age.nix"
          "${copyparty}/contrib/nixos/modules/copyparty.nix"
          "${preservation}/module.nix"
#           ./Pkgs
          ./configuration.nix
          (builtins.getAttr selectedHost hostConfigs)
        ];

        nixpkgs.overlays = [
          (import "${copyparty}/contrib/package/nix/overlay.nix")
        ];

        home-manager.extraSpecialArgs = {
          nur = nurPkgs;
        };

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
  Practice-Server = mkSystem "Practice-Server";
}
