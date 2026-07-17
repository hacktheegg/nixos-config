{}:

let
  # Pinned Nixpkgs archive
  #
  # Use `curl -I https://channels.nixos.org/nixos-26.05` to get the
  # latest commit of the stable channel and `nix-prefetch-url --unpack`
  # to compute its sha256 hash.
  nixpkgs = builtins.fetchTarball {
    url = "https://releases.nixos.org/nixos/26.05/nixos-26.05.4659.8f0500b96605/nixexprs.tar.xz";
    sha256 = "sha256:1am0mgbc9xsj8n3mgb8pznggl87s4blagada88zdcynr01qbpj36";
  };
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/3cd22efe6471dc7365c822bd9ad73a21e55f38fb.tar.gz"; # branch:release-26.05
    sha256 = "sha256:1lpx1xf1dsd4k7yp61alh135rhlsy7hzl924l2vd3nsqyqfz5a59";
  };
  agenix = builtins.fetchTarball {
    url = "https://github.com/ryantm/agenix/archive/b027ee29d959fda4b60b57566d64c98a202e0feb.tar.gz"; # branch:main
    sha256 = "sha256:1wlpvpj45qfixdzhmk2cgiwlkyaf8a5mjy2jp5lsx2wsxblclngm";
  };
  copyparty = builtins.fetchTarball {
    url = "https://github.com/9001/copyparty/archive/daee3e85001a7bb8716577e84b01aafce8f813bb.tar.gz"; # branch:hovudstraum
    sha256 = "sha256:0iblhd462bkl40g4ah5ys3c35f03civkf6k8migb9lq41yncnk56";
  };
  nur = import ( builtins.fetchTarball {
    url = "https://github.com/nix-community/NUR/archive/251d877a207cddbf0adc5d46f0a9d5bd41c2e029.tar.gz"; # branch:main
    sha256 = "sha256:191g9zsqnwismhnc3k968rqs2qq7ksijbrahg8wf776nhwghfb23";
  } ) {};



  hostConfigs = { ### MARKER ###
    Thinkpad-T460 = ./Builds/Thinkpad-T460.nix;
    HP-Mini = ./Builds/HP-Mini.nix;
  };

  #
  # I hate having to do this
  #
  mkSystem = selectedHost:
    import "${nixpkgs}/nixos" {
      # Build NixOS using an external configuration.nix file,
      # or directly set your options here
      configuration = {
        imports = [
          "${home-manager}/nixos"
          "${agenix}/modules/age.nix"
          "${copyparty}/contrib/nixos/modules/copyparty.nix"
          ./configuration.nix
          (builtins.getAttr selectedHost hostConfigs)
        ];

        nixpkgs.overlays = [
          (import "${copyparty}/contrib/package/nix/overlay.nix")
          (final: prev: { nur = import nur { }; })
        ];

        home-manager.extraSpecialArgs = {
          inherit nur;
        };
      };
    };

in
{

  Thinkpad-T460 = mkSystem "Thinkpad-T460";
  HP-Mini = mkSystem "HP-Mini";
}
