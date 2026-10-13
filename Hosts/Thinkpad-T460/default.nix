{ pkgs, config, ... }:
{
  imports = [
    ./../../Modules
    ./../../Users/hacktheegg.nix
    ./hardware-configuration.nix
  ];

  config = {
    age.secrets = {
      ntfy-creds = {
        file = ./Secrets/ntfy-creds.age;
        mode = "0400";
        owner = "nobody";
      };
      ntfy-url = {
        file = ./Secrets/ntfy-url.age;
        mode = "0400";
        owner = "nobody";
      };
    };
    environment.systemPackages = with pkgs; [
      alacritty
      cloudflared
      dig
      host
      sqlite
      sqlitebrowser
    ];
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.Policy.AutoEnable = true;
    };
    i18n.defaultLocale = "en_AU.UTF-8";
    networking = {
      hostName = "Thinkpad-T460";
      networkmanager.enable = true;
    };
    nixpkgs.config.allowUnfree = true;
    omelette = {
      boot.efi.enable = true;
      services.update-alert = {
        credentials = config.age.secrets.ntfy-creds.path;
        enable = true;
        url = config.age.secrets.ntfy-url.path;
      };
    };
    powerManagement.cpuFreqGovernor = "powersave";
    preservation = {
      enable = true;
      preserveAt."/persist" = {
        directories = [
          "/etc/NetworkManager/system-connections"
          "/var/lib/bluetooth"
          "/var/lib/nixos"
          "/var/lib/systemd"
          "/var/log"
        ];
        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
          }
          {
            file = "/etc/ssh/ssh_host_ed25519_key";
            mode = "0600";
          }
          {
            file = "/etc/ssh/ssh_host_ed25519_key.pub";
            mode = "0644";
          }
        ];
        users.hacktheegg = {
          directories = [
            "./.cache/Proton"
            "./.cache/keepassxc"
            "./.cache/protonmail"
            "./.cache/thunderbird"
            "./.config/equibop"
            "./.config/gnome-boxes"
            "./.config/gnome-games"
            "./.config/jellyfin-mpv-shim"
            "./.config/kate"
            "./.config/keepassxc"
            "./.config/libvirt"
            "./.config/protonmail"
            "./.librewolf"
            "./.local/share/dolphin"
            "./.local/share/gnome-boxes"
            "./.local/share/kate"
            "./.local/share/kwrite"
            "./.local/share/protonmail"
            "./.nix-package-search"
            "./.thunderbird"
            "./Persist"
            "./home-config"
            "./thunderbird"
          ];
          files = [
            "./.config/dolphinrc"
            "./.config/katerc"
            "./.config/katevirc"
            "./.config/kwriterc"
            "./.local/state/dolphinstaterc"
            "./.local/state/kwritestaterc"
            "./home.nix"
          ];
        };
      };
    };
    programs = {
      dconf.enable = true;
      localsend = {
        enable = true;
        openFirewall = true;
      };
      sway.enable = true;
    };
    security.polkit.enable = true;
    services = {
      blueman.enable = true;
      displayManager.sddm.enable = true;
      fstrim.enable = true;
      gvfs.enable = true;
      libinput = {
        enable = true;
        mouse.disableWhileTyping = true;
        touchpad.disableWhileTyping = true;
      };
      openssh = {
        enable = true;
        hostKeys = [
          {
            path = "/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
        ];
      };
      pipewire = {
        alsa.enable = true;
        alsa.support32Bit = true;
        enable = true;
        pulse.enable = true;
      };
      thermald.enable = true;
      udisks2.enable = true;
      xserver.enable = true;
    };
    system.stateVersion = "25.11";
    time.timeZone = "Australia/NSW";
  };
}
