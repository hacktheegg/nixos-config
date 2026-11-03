{ config, lib, ... }:
{

  imports = [
    ./jellyfin.nix
    ./media.nix
    ./qbittorrent.nix
    ./restic-server.nix
    ./reverse-proxy.nix
  ];
}
