{ pkgs, config, ... }:
{
  imports = [
    ./../Hardware/Thinkpad-T460.nix
#     ./../Modules/Boot/efi.nix

    ./../Users/hacktheegg.nix


    ./../Modules
  ];

  system.stateVersion = "25.11";

  omelette.boot.efi.enable = true;

  omelette.containers.media.enable = false;

#   omelette.networks.bridges = {
#     custom = {
#       name = "br-custom";
#       gateway = "10.100.0.1";
# #       subnet = "10.100.0.0/24";
#     };
#   };

#   omelette.containers.qbittorrent.incompletePath = "/tmp/qbit/incomplete";
#   omelette.containers.qbittorrent.completedPath = "/tmp/qbit/complete";
#   omelette.containers.reverse-proxy.cloudflared.enable = true;
#   omelette.containers.reverse-proxy.enable = true;
#   omelette.containers.reverse-proxy.bridge = config.omelette.networks.bridges.custom;


  #######

  networking.hostName = "Thinkpad-T460"; # Define your hostname.
  networking.networkmanager.enable = true;
  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.Policy.AutoEnable = true;
  };
  services.blueman.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };



  time.timeZone = "Australia/NSW";
  i18n.defaultLocale = "en_AU.UTF-8";

  nixpkgs.config.allowUnfree = true;
  programs.dconf.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  security.polkit.enable = true;

  services.xserver.enable = true;
  #   services.xserver.xkb.layout = "us";

  services = {
    displayManager.sddm.enable = true;
    libinput = {
      enable = true;
      mouse.disableWhileTyping = true;
      touchpad.disableWhileTyping = true;
    };
  };
  programs.sway = {
    enable = true;
    #     wrapperFeatures.gtk = true;
  };


  virtualisation.libvirtd = {
    enable = true;
    #     qemu = {
    #       swtpm.enable = true;
    #       ovmf.packages = [ pkgs.OVMFFull.fd ];
    #     };
  };

  # Enable USB redirection
  virtualisation.spiceUSBRedirection.enable = true;

  # Allow VM management
  users.groups.libvirtd.members = [ "hacktheegg" ];
  users.groups.kvm.members = [ "hacktheegg" ];

  # Enable VM networking and file sharing
  environment.systemPackages = with pkgs; [
    # ... your other packages ...
    gnome-boxes # VM management
    dnsmasq # VM networking
    phodav # (optional) Share files with guest VMs


    cloudflared
    dig
    host

    sqlitebrowser
    sqlite

    alacritty

    sl
  ];

  services.openssh = {
    enable = true;
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  boot.tmp.cleanOnBoot = true;

  services.fstrim.enable = true;
  powerManagement.cpuFreqGovernor = "powersave";
  services.thermald.enable = true;
  preservation = {
    enable = true;

    preserveAt."/persist" = {

      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
        }
#         "/etc/passwd"
#         "/etc/shadow"
#         "/etc/group"
#         "/etc/gshadow"
        {
          file = "/etc/ssh/ssh_host_ed25519_key";
          mode = "0600";
        }
        {
          file = "/etc/ssh/ssh_host_ed25519_key.pub";
          mode = "0644";
        }
      ];

      directories = [
        "/etc/NetworkManager/system-connections"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd"
        "/var/log"
      ];

      users.hacktheegg = {
        directories = [
          "./.cache/keepassxc"
          "./.cache/Proton"
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
          "./home-config"
          "./Persist"
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

#   boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_12;
}
