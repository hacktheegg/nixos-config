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
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
#     settings.Policy.AutoEnable = true;
  };

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

  nixpkgs.config.allowUnfree = true;

#   environment.systemPackages = with pkgs; [
#     librewolf
#   ];

  programs.steam.enable = true;

  services = {
    displayManager.plasma-login-manager.enable = true;
    desktopManager.plasma6.enable = true;
  };

  services.comin = {
    enable = true;
    sshAllowedSignersPath = "${pkgs.writeTextFile {
      name = "allowed-signers";
      text = ''
        hacktheegg@hacktheegg.cc ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3G3MXV0lULAAMHHR5vj8rOD+9mc/jAuvbbKOQ/jTrH agenix recovery
      '';
    }}";
    remotes = [
      {
        name = "origin";
        url = "https://git.hacktheegg.cc/hacktheegg/nixos-config.git";
        branches = {
          main = {
            name = "main";
            operation = "switch";
          };
          testing.name = "";
        };
      }
    ];
    repositoryType = "nix";
    systemAttr = "Inspiron-2n1";
  };

  system.stateVersion = "25.11";
}
