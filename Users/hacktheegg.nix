{ ... }:

{

  users.users.hacktheegg = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "input"
      "audio"
      "libvirtd"
      "video"
      "render"
      "docker"
      "kvm"
      "wheel"
    ];
    initialPassword = "abc";
    home = "/home/hacktheegg";
  };

  home-manager.users = {
    hacktheegg = { config, pkgs, nur, ... }: {
      home.stateVersion = "25.11";
      programs.obsidian = {
        enable = true;
        vaults = {
          "Documents" = {
            enable = true;
            target = "Persist/Documents";
          };
        };
      };
      programs.equibop = {
        enable = true;
        settings = { # $XDG_CONFIG_HOME/equibop/settings.json
          "discordBranch" = "stable";
          "minimizeToTray" = false;
          "arRPC" = false;
        };
        equicord.settings = { # $XDG_CONFIG_HOME/equibop/settings/settings.json
          "autoUpdate" = false;
          "autoUpdateNotification" = true;
        };
      };
      imports = [
        ./dark-mode-GTK.nix
        ./dark-mode-QT.nix
        #         ./dark-mode-KDE.nix
      ] ++ ( if builtins.pathExists /home/hacktheegg/home.nix then [ /home/hacktheegg/home.nix ] else [ ] );
      programs.home-manager.enable = true;
      programs.librewolf = {
        enable = true;
        profiles = {
          "Original" = {
            isDefault = true;
            id = 0;
            extensions.packages = with nur.repos.rycee.firefox-addons; [
              ublock-origin
              noscript
              floccus
              indie-wiki-buddy
              ruffle_rs
              keepassxc-browser
            ];
            settings = {
              "sidebar.verticalTabs" =                          true;
              "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
            };
          };
          "I2P" = {
            isDefault = false;
            id = 1;
            extensions.packages = with nur.repos.rycee.firefox-addons; [
              ublock-origin
              noscript
            ];

            settings = {
              "browser.contentblocking.category" =    "strict";
              "dom.security.https_only_mode" =        false;
              "javascript.enabled" =                  false;
              "keyword.enabled" =                     false;
              "network.proxy.backup.ssl" =            "127.0.0.1";
              "network.proxy.backup.ssl_port" =       4444;
              "network.proxy.http" =                  "127.0.0.1";
              "network.proxy.http_port" =             4444;
              "network.proxy.share_proxy_settings" =  "true";
              "network.proxy.socks" =                 "127.0.0.1";
              "network.proxy.socks_port" =            4447;
              "network.proxy.ssl" =                   "127.0.0.1";
              "network.proxy.ssl_port" =              4444;
              "network.proxy.type" =                  1;
            };
          };
        };
      };
      programs.chromium = {
        enable = true;
        extensions = [
          { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
        ];
      };
      xdg = {
        autostart.enable = true;
        mime.enable = true;
        mimeApps.enable = true;
        terminal-exec.enable = true;
        portal = {
          enable = true;
          extraPortals = with pkgs; [
            xdg-desktop-portal-wlr
            kdePackages.xdg-desktop-portal-kde
          ];
          config = {
            common = {
              default = [
                "kde"
                "wlr"
              ];
            };
          };
        };
        userDirs = {
          enable = true;
          createDirectories = true;
          setSessionVariables = true;

          desktop = "${config.home.homeDirectory}/Persist/Desktop";
          documents = "${config.home.homeDirectory}/Persist/Documents";
          download = "${config.home.homeDirectory}/Persist/Downloads";
          music = "${config.home.homeDirectory}/Persist/Music";
          pictures = "${config.home.homeDirectory}/Persist/Pictures";
          projects = "${config.home.homeDirectory}/Persist/Projects";
          publicShare = "${config.home.homeDirectory}/Persist/Public-Share";
          templates = "${config.home.homeDirectory}/Persist/Templates";
          videos = "${config.home.homeDirectory}/Persist/Videos";

          #           extraConfig = {
          #             PROGRAMMING = "${config.home.homeDirectory}/Persist/Programming";
          #           };
        };
        desktopEntries.librewolf-i2p = {
          name = "LibreWolf (I2P)";
          genericName = "Web Browser";

          exec = "${pkgs.librewolf}/bin/librewolf --name librewolf-i2p -P I2P -no-remote %U";

          icon = "librewolf";

          terminal = false;
          startupNotify = true;

          categories = [ "Network" "WebBrowser" ];

          mimeType = [
            "text/html"
            "text/xml"
            "application/xhtml+xml"
            "application/vnd.mozilla.xul+xml"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
          ];

          settings = {
            StartupWMClass = "librewolf-i2p";
            Actions = "new-private-window;new-window";
          };

          actions = {
            new-window = {
              name = "New Window";
              exec = "${pkgs.librewolf}/bin/librewolf --name librewolf-i2p -P I2P -no-remote --new-window %U";
            };

            new-private-window = {
              name = "New Private Window";
              exec = "${pkgs.librewolf}/bin/librewolf --name librewolf-i2p -P I2P -no-remote --private-window %U";
            };
          };
        };
      };
      services.lxqt-policykit-agent = {
        enable = true;
      };
    };
  };

}
