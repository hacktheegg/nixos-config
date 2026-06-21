{ pkgs, ... }:


let

  # Move the derivation into a 'let' binding for cleanliness
  wallpaperPkg = pkgs.stdenv.mkDerivation {
    name = "secureblue-wallpapers";
    src = ./../Resources/backgrounds.zip;
    nativeBuildInputs = [ pkgs.unzip ];

    # Use unpackPhase to ensure the zip is actually extracted
    # or just let the default behavior happen by removing manual phases
    installPhase = ''
      mkdir -p $out/secureblue
      cp -r . $out/secureblue/
    '';
  };

in

{
  imports =
    [
      ./../Hardware/Thinkpad-T460.nix
      #<home-manager/nixos>

      ./../Containers/i2p.nix

      ./../Modules/bluetooth.nix
      ./../Modules/bootloader.nix
      ./../Modules/copyparty.nix
      ./../Modules/desktop.nix
      ./../Modules/git.nix
      ./../Modules/mailserver.nix
      ./../Modules/mpd.nix
      ./../Modules/mpv.nix
      ./../Modules/network.nix
      ./../Modules/password-store.nix
      ./../Modules/printing.nix
      # ./../Modules/qbittorrent.nix
      ./../Modules/qemu.nix

      ./../Users/hacktheegg.nix
      ./../Users/root.nix
    ];



  environment.systemPackages = with pkgs; [
    ffmpeg
    lutris
    pass
    vlc-bittorrent
    conky
    element-desktop

    protonmail-bridge-gui

    nulloy


    solaar
    jellyfin-mpv-shim
    picard
    glslang

    nixos-artwork.wallpapers.catppuccin-mocha

    easyeffects
    qpwgraph

    wireguard-tools
    protonvpn-gui

    kdePackages.kdenlive
    pantheon.elementary-camera
    nicotine-plus

    cloudflared

    wine

    #sl


#     virt-manager
#     virt-viewer # For occasional debugging if SSH fails
#     libvirt
#     snapshot





    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav






    (stdenv.mkDerivation {
      installPhase = ''
        mkdir -p $out/share/icons/oreo-spark-violet-cursor-theme
        tar -xzf $src -C $out/share/icons/oreo-spark-violet-cursor-theme --strip-components=1
        rm $out/share/icons/oreo-spark-violet-cursor-theme/index.theme
      '';
      name = "oreo-spark-violet-cursor-theme";
      src = ./../Resources/oreo-spark-violet-cursors.tar.gz;
      unpackPhase = "true";
    })

    #(stdenv.mkDerivation {
      #nativeBuildInputs = [ unzip ];
      #installPhase = ''
      #  mkdir -p $out/share/backgrounds
      #  cp -r . $out/share/backgrounds
      #'';
      #name = "secureblue-wallpapers";
      #src = ./../Resources/backgrounds.zip;
      #unpackPhase = "true";
    #})

    wallpaperPkg

    (pkgs.callPackage <agenix/pkgs/agenix.nix> {})

    yt-dlp

  ];

  #environment.shellAliases = {
  #  deadswitch = "run0 /etc/nixos/Scripts/Dead_Switch.sh";
  #};

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
    # Add any other core libs if the error persists
  ];

  networking.firewall.checkReversePath = false;

  security.sudo.enable = false;

  services.ntfy-sh = {
    settings.base-url = "https://ntfy.hacktheegg.cc";
    enable = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d --quiet";
    persistent = true;
    randomizedDelaySec = "1d";
  };
  nix.optimise = {
    automatic = true;
    persistent = true;
    randomizedDelaySec = "240min";
  };

  zramSwap = {
    enable = true;
    memoryPercent = 50;
    priority = 10;
    algorithm = "zstd";
  };
  systemd.oomd.enable = false;
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 10;
    freeSwapThreshold = 10;
    enableNotifications = true;
    extraArgs = [
      "-r 0.05"
    ];
  };
  boot.kernel.sysctl = {
    "vm.swappiness" = 158;
    "vm.vfs_cache_pressure" = 150;
    "vm.watermark_boost_factor" = 0;
  };



  services.libretranslate.enable = false;



  environment.etc."backgrounds".source = "${wallpaperPkg}/secureblue";


  environment = {
    sessionVariables = {
        XCURSOR_THEME = "oreo-spark-violet-cursor-theme";
    };
  };

  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.jetbrains-mono
    maple-mono.NF-CN-unhinted
  ];
  #fonts.fontconfig = {
  #  enable = true;
  #  defaultFonts = {
  #    emoji =     [ "Maple Mono NF CN" ];
  #    monospace = [ "Maple Mono NF CN" ];
  #    sansSerif = [ "Maple Mono NF CN" ];
  #    serif =     [ "Maple Mono NF CN" ];
  #  };
  #};

  time = {
    timeZone = "Australia/NSW";
    hardwareClockInLocalTime = false;
  };
  nixpkgs.config.allowUnfree = true;

  programs = {
    localsend.enable = true;
    localsend.openFirewall = true;
    htop.enable = true;
    steam.enable = true;
    thunderbird.enable = true;
    tmux.enable = true;
    vim.enable = true;
    waybar.enable = true;

  };


  virtualisation.waydroid.enable = true;
  #boot.kernelModules = [ "ashmem_linux" "binder_linux" ];


  services = {
    fwupd.enable = true;
  };



  age.secrets.restic-repo-password.file = ./../Secrets/restic-repo-password.age;
  age.secrets.restic-env.file = ./../Secrets/restic-env.age;
  services.restic.backups.home-backup = {
    paths = [ "/home/hacktheegg" ];

    repository = "rest:https://restic.hacktheegg.cc/hacktheegg";

    passwordFile = "/run/agenix/restic-repo-password";
    
    environmentFile = "/run/agenix/restic-env";

    initialize = true;

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };

    extraBackupArgs = [
      "--exclude='.cache'"
      "--exclude='.hist'"
      "--exclude='.local/share/Steam'"
      "--exclude='.local/share/waydroid'"
      "--exclude='Videos/DRSTONE'"
      "--exclude='Videos/REZERO'"
    ];
  };



#   services.rustdesk-server = {
#     enable = true;
#     openFirewall = false;
# #     signal.relayHosts = ["example.com"];
#   };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
