{ pkgs, ... }:

{

  users.users.hacktheegg = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "input" "audio" "libvirtd" "video" "render" "docker" "kvm" ];
  };


  home-manager.users = {
    hacktheegg = {
      home.stateVersion = "25.11";

      imports = [
        ./Modules/chromium.nix
        ./Modules/equibop.nix
        ./Modules/librewolf.nix
        ./Modules/passwordstore.nix
      ];

      programs = {
        bash = {
          enable = true;
          bashrcExtra = ''
            fastfetch
            df -h
            echo "nixos-rebuild switch -I nixos-config=/etc/nixos/configuration.nix"
            echo "journalctl -p 3 -b"
          '';
        };
        swaylock = {
          enable = true;
          package = null;
        };
        rofi = {
          enable = true;
          theme = "android_notification.rasi";
          pass = {
            enable = true;
            stores = [ "/home/password-store" ];
            package = pkgs.rofi-pass-wayland;
          };
        };
        #chromium.enable = true;
      };
      services = {
        flameshot = {
          enable = true;
          settings = {
            General = {
              savePathFixed = true;
              useGrimAdapter = true;
            };
          };
        };
        gammastep = {
          enable = true;
          #settings = {
          #  gamma = "1.0:1.0:0.8";
          #};
          temperature = {
            day = 3500;
            night = 3000;
          };
          provider = "manual";
          dawnTime = "6:00-7:00";
          duskTime = "17:00-18:00";
        };
        #protonmail-bridge = {
        #  enable = true;
        #};
      };
    };
  };

}
