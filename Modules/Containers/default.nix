{ config, lib, ... }:
{

  imports = [
    ./jellyfin.nix
    ./media.nix
    ./qbittorrent.nix
    ./reverse-proxy.nix
  ];
}
