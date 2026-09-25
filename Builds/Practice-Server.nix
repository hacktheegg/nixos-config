{ pkgs, config, ... }:

# let
#   ntfyLogin = pkgs.writeShellScript "ntfy-ssh-login" ''
#     (
#       ${pkgs.curl}/bin/curl -fsS \
#         -H "Title: SSH login" \
#         -d "SSH login: user=$PAM_USER host=$(hostname) from=$PAM_RHOST" \
#         https://ntfy.example.com/device-logins
#     ) &
#   '';
# in
{
  imports = [
    ./../Hardware/Practice-Server.nix

#     ./../Users/hacktheegg.nix

    ./../Modules
  ];

  omelette.boot.efi.enable = true;

  /*
    * 10% Music
    * 45% Movies
    * 45% Shows
  */

  age.secrets.tunnel-token-practice-server.file = ../Secrets/Tunnel-Token-Practice-Server.age;

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
      reverse-proxy = {
        enable = true;
        cloudflared = {
          enable = true;
          token = config.age.secrets.tunnel-token-practice-server.path;
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



  age.secrets.weston-desktop-tls.file = ../Secrets/weston-desktop-tls.age;

  containers.weston-desktop = {
    autoStart = false;

    bindMounts = {
      "/run/agenix/weston-desktop-tls" = {
          hostPath = config.age.secrets.weston-desktop-tls.path;
          isReadOnly = true;
        };
      };

    config = { config, pkgs, ... }: {
      system.stateVersion = "25.11";

      users.users.weston = {
        isSystemUser = true;
        group = "weston";
        home = "/var/lib/weston";
        createHome = true;
      };

      users.groups.weston = {};


      nixpkgs.config.allowUnfree = true;

      environment.systemPackages = with pkgs; [
        weston
        alacritty
        foot
      ];

      systemd.services.weston-rdp = {
        description = "Run Weston in RDP mode.";

        enable = true;

        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];

        serviceConfig = {
          Restart = "on-failure";
          RestartSec = "5s";
          User = "weston";
          Group = "weston";
          ExecStart = "${pkgs.weston}/bin/weston --backend=rdp --rdp-tls-key=/run/agenix/weston-desktop-tls";
        };
      };
    };
  };



  services.ntfy-sh = {
    enable = true;

    settings = {
      base-url = "https://ntfy.hacktheegg.cc";
      listen-http = ":80";
      behind-proxy = true;
    };
  };
#   security.pam.services.sshd.rules.session.ntfy-login = {
#     order = 1500;
#     control = "optional";
#     modulePath = "${pkgs.pam_exec}/lib/security/pam_exec.so";
#     args = "${ntfyLogin}";
#   };




  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "ad3ea6e7";
  boot.zfs.forceImportRoot = false;
  boot.zfs.extraPools = [ "zmedia" ];
  services.zfs.trim.enable = false;
  services.zfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };





  system.stateVersion = "25.11";

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
    IdleAction = "ignore";
  };


### BLANK HDMI SCREEN ###
  boot.kernelParams = [
    "video=eDP-1:d"
    "consoleblank=300"
  ];

  specialisation = {
    enable-screen = {
      inheritParentConfig = true;
      configuration = {
        boot.kernelParams = [
          "video=eDP-1:e"
        ];
        system.nixos.tags = [ "enable-screen" ];
      };
    };
  };

#   systemd.services.console-blank = {
#     description = "Blank Linux consoles after inactivity";
#     wantedBy = [ "multi-user.target" ];
#
#     serviceConfig = {
#       Type = "oneshot";
#       ExecStart = pkgs.writeShellScript "console-blank" ''
#         for tty in /dev/tty[1-9]*; do
#           ${pkgs.util-linux}/bin/setterm --blank 5 --powerdown 5 < "$tty" > "$tty" 2>/dev/null || true
#         done
#       '';
#     };
#   };
### BLANK HDMI SCREEN ###





  networking.hostName = "Practice-Server"; # Define your hostname.
  networking.networkmanager.enable = true;


  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.Policy.AutoEnable = true;
  };
#   services.blueman.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    bluetui
    mpv
    wiremix
    cgminer
    waypipe
  ];


  time.timeZone = "Australia/NSW";
  i18n.defaultLocale = "en_AU.UTF-8";

  nixpkgs.config.allowUnfree = true;


  users.users = {
    hacktheegg = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFXh6RiiBaXYWLo69xZS7c9d3DriJI4dVaj/fVlfNWJi nixos host key"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3G3MXV0lULAAMHHR5vj8rOD+9mc/jAuvbbKOQ/jTrH agenix recovery"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+cXDNU7PAa7gxV+1iZ2+agsxEE2T9FAIOHjwrIvx+9 trmwdc@gmail.com"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5ObBl3+9+6RsvhLo0SvBwZISP8MZ7I4VDBKIE+Se18 marley@marley-laptop-mint"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE+WPY9B4z8mRavi7xNMPiV++SZVKHzlnBxoSuggA1UN nedaa@Computer"
      ];
      initialPassword = "abc";
    };
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



#   services.openssh = {
#     enable = true;
#     hostKeys = [
#       {
#         path = "/etc/ssh/ssh_host_ed25519_key";
#         type = "ed25519";
#       }
#     ];
#   };




#   age.secrets.copyparty-pass = {
#     file = ./../Secrets/test-secret.age;
#     owner = "hacktheegg";
#     group = "users";
#   };


  networking.firewall.allowedTCPPorts = [ 3923 ];

  services = {
    copyparty = {
      enable = true;
      user = "hacktheegg";
      group = "users";
      settings = {
        e2dsa = false;
        e2ts = false;
        #ipa = "127.0.";
        ah-alg = "argon2";
      };

      #extraArgs = [
      #  "--no-check"     # Skip the heavy integrity check on startup
      #  "--db-strict 0"  # Don't force a disk sync on every single write (massive speedup)
      #  "--p-reindex 0"  # Don't try to re-index existing files on start
      #];

      #accounts.hacktheegg.passwordFile = "/etc/nixos/Resources/copypartyPass";
      accounts.hacktheegg.passwordFile = "/etc/nixos/Secrets/copyparty-pass.txt";


      volumes."/" = {
        path = "/home/hacktheegg";
        access.rwmda = [ "hacktheegg" ];
        flags = {
          d2d = true;
          d2t = true;
        };
      };
    };
  };



#   boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_12;
}
