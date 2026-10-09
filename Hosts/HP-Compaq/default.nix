{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./../../Modules
  ];

  # omelette.boot.efi.enable = true;

  omelette.boot.bios.enable = true;
  omelette.boot.bios.device = "/dev/sda";

  networking.hostName = "HP-Compaq";

  networking.networkmanager.enable = true;

  users.users = {
    root = {
      initialPassword = "abc";
    };
  };

  time.timeZone = "Australia/NSW";
  i18n.defaultLocale = "en_AU.UTF-8";

  services.openssh = {
    enable = true;
  };

  system.stateVersion = "25.11";
}
