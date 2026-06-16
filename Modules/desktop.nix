{ config, lib, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    fastfetch
    nmap
    p7zip
    vim

    vlc
    pwvucontrol
    kdePackages.dolphin
    kdePackages.filelight
    kdePackages.kate
    networkmanagerapplet
    adwaita-icon-theme

    kdePackages.okular
    librewolf
    obsidian # Unfree
    vesktop # Unfree
    gimp
    libreoffice
    tor-browser
    vscodium
    qalculate-qt
    aisleriot

    swaynotificationcenter
    libnotify

    kdePackages.breeze
    kdePackages.breeze-gtk
    kdePackages.breeze-icons
    kdePackages.kcolorscheme
    (pkgs.kdePackages.plasma-desktop)
    adwaita-qt
    glib
    xdg-utils
    gsettings-desktop-schemas

    libpwquality

    kdePackages.qt6ct
    kdePackages.qqc2-desktop-style
    kdePackages.kirigami
    libsForQt5.qt5ct

    kdePackages.konsole

    nil
    bash-language-server

#     libsForQt5.breeze-qt5

    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum

    swww

  ];


  services.dbus.packages = [
    pkgs.gsettings-desktop-schemas
    pkgs.kdePackages.dolphin
  ];


  qt = {
    enable = true;
#     platformTheme = "qt6ct";
#     style = lib.mkForce "breeze";
  };

#   environment.etc."xdg/kdeglobals".text = ''
#     [General]
#     ColorScheme=BreezeDark
#
#     [Colors:Window]
#     BackgroundNormal=45,52,54
#     ForegroundNormal=211,215,207
#
#     [KDE]
#     widgetStyle=Breeze
#   '';

  environment.etc."xdg/qt5ct/qt5ct.conf".text = ''
    [Appearance]
    style=breeze
  '';
  environment.etc."xdg/qt6ct/qt6ct.conf".text = ''
    [Appearance]
    style=breeze
  '';

  environment.etc = {
    "xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=Breeze-Dark
      gtk-icon-theme-name=breeze-dark
      gtk-application-prefer-dark-theme=1
    '';
    "xdg/gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=Breeze-Dark
      gtk-icon-theme-name=breeze-dark
      gtk-application-prefer-dark-theme=1
    '';
  };

  environment.sessionVariables = {
    QT_PLUGIN_PATH = [ "${pkgs.kdePackages.breeze}/lib/qt-6/plugins" ];
    XDG_DATA_DIRS = [
      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
      "${pkgs.kdePackages.breeze-icons}/share"
#       "${pkgs.kdePackages.plasma-desktop}/share"
    ];
#     XDG_CURRENT_DESKTOP = "sway";
    XDG_MENU_PREFIX = "plasma-";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    XDG_CURRENT_DESKTOP = "KDE";
#     QT_STYLE_OVERRIDE = "breeze";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk # Elementary/GTK apps need this fallback
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
    #config.common.default = [ "gtk" "wlr" ];
    config.common.default = "*";
  };

  programs.dconf.enable = true;
  nixpkgs.config.allowUnfree = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  services = {
    displayManager.sddm.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      wireplumber.enable = true;
      jack.enable = true;
    };
    xserver.enable = true;
    libinput = {
      enable = true;
      mouse.disableWhileTyping = true;
      touchpad.disableWhileTyping = true;
    };
  };

  environment = {
    etc."sway/config".source = ./../Configs/sway.conf;
    etc."xdg/waybar/config".source = ./../Configs/config.jsonc;
    etc."xdg/waybar/style.css".source = ./../Configs/style.css;
  };


  xdg.mime = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "org.kde.dolphin.desktop";
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      #"application/pdf" = "org.pwmt.zathura.desktop";
      #"image/png" = "org.nomacs.ImageLounge.desktop";
      #"image/jpeg" = "org.nomacs.ImageLounge.desktop";
      "video/mp4" = "mpv.desktop";
    };
  };


  systemd.user.services.lxqt-policykit-agent = {
    description = "LXQt PolicyKit Authentication Agent";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
      Restart = "on-failure";
    };
  };
  #systemd.services.display-manager.serviceConfig.NoNewPrivileges = true;

  #security.pam.services.swaylock.text = "auth include login";
  security.pam.services.swaylock = {};
  # programs.swaylock = {
  #   enable = true;
  #   package = pkgs.swaylock; # or pkgs.swaylock-effects
  # };

  security.polkit.enable = true;

  services.gvfs.enable = true;
  services.udisks2.enable = true;

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
