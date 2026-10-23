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
    systemAttr = "HP-Compaq";
  };

  system.stateVersion = "25.11";
}
