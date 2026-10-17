{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./../../Modules
  ];

  omelette.boot.efi.enable = true;
  omelette.boot.efi.useOSProber = true;

  # omelette.boot.bios.enable = true;
  # omelette.boot.bios.device = "/dev/sda";

  ## SET THIS VALUE
  networking.hostName = "Inspiron-2n1";

  networking.networkmanager.enable = true;

  users.users = {
    hacktheegg = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      initialPassword = "abc";
      home = "/home/hacktheegg";
    };
    root = {
      initialPassword = "abc";
    };
  };

  time.timeZone = "Australia/NSW";
  i18n.defaultLocale = "en_AU.UTF-8";

  services.openssh = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    librewolf
  ];

  services = {
    displayManager.plasma-login-manager.enable = true;
    desktopManager.plasma6.enable = true;
  };

  system.stateVersion = "25.11";
}
