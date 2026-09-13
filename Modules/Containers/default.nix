{ config, lib, ... }:
{

  imports = [
    ./jellyfin.nix
    ./media.nix
    ./reverse-proxy.nix
  ];
}
