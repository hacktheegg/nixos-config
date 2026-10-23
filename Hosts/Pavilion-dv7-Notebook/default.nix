{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix

    ./../../Modules
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.useOSProber = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "hp-win7";

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users = {
    root = {
      initialPassword = "abc";
    };
    jason = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      initialPassword = "abc";
    };
  };

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
  };
  services.displayManager.defaultSession = "xfce";

  time.timeZone = "Australia/NSW";
  i18n.defaultLocale = "en_AU.UTF-8";

  environment.systemPackages = with pkgs; [
    alacritty
    foot
    vlc
    mpv
    librewolf
    chromium
  ];

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
    systemAttr = "Pavilion-dv7-Notebook";
  };

  system.stateVersion = "25.11";
}
