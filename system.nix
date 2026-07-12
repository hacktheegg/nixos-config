let
  # Pinned Nixpkgs archive
  #
  # Use `curl -I https://channels.nixos.org/nixos-26.05` to get the
  # latest commit of the stable channel and `nix-prefetch-url --unpack`
  # to compute its sha256 hash.
  nixpkgs = builtins.fetchTarball {
    url = "//releases.nixos.org/nixos/26.05/nixos-26.05.4659.8f0500b96605/nixexprs.tar.xz";
    sha256 = "026mprs324330pfazlgbw987qmsa8ligglarvqbcxzig2kgw0lqg";
  };
in
import "${nixpkgs}/nixos" {
  # Build NixOS using an external configuration.nix file,
  # or directly set your options here
  configuration = ./configuration.nix;
}
