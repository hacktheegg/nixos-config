{ pkgs, config, ... }:

{
  imports = [

    ./../Modules
  ];

  omelette.boot.efi.enable = true;


  omelette = {
    containers = {
      jellyfin = {
        enable = true;
        cacheDir = "/cache/jellyfin/cache";
        configDir = "/cache/jellyfin/config";
        dataDir = "/cache/jellyfin/data";
        mounts = [
          "/media/static/jellyfin/Anime"
          "/media/static/jellyfin/Movies"
          "/media/static/jellyfin/Music"
          "/media/static/jellyfin/Shows"
        ];
      };
      media = {
        enable = true;
        mounts = [
          "/media/static"
        ];
        radarr = {
          enable = true;
          dataDir = "/cache/servarr/radarr/data";
          webPort = 7878;
        };
        sonarr = {
          enable = true;
          dataDir = "/cache/servarr/sonarr/data";
          webPort = 8989;
        };
        lidarr = {
          enable = true;
          dataDir = "/cache/servarr/lidarr/data";
          webPort = 8686;
        };
      };
      qbittorrent = {
        enable = true;
        profileDir = "/cache/qbittorrent/profileDir";
        mounts = [
          "/media/static/qbittorrent"
          "/cache/qbittorrent/incomplete"
        ];
        webPort = 1284;
      };
    };
  };



  system.stateVersion = "25.11";


  networking.hostName = "HP-Win7-NixOS"; # Define your hostname.
  networking.networkmanager.enable = true;


  services.pipewire = {
     enable = true;
     pulse.enable = true;
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

  nixpkgs.config.allowUnfree = true;


  users.users = {
    root = {
      initialPassword = "abc";
    };
  };

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  environment.systemPackages = with pkgs; [
    alacritty
    foot
    vlc
    mpv
  ];
}
