{ config, lib, ... }:
{

  imports = [
    ./jellyfin.nix
    ./reverse-proxy.nix
  ];
}
