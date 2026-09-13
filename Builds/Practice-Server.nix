{ pkgs, config, ... }:
{
  imports = [
    ./../Hardware/Practice-Server.nix
#     ./../Modules/Boot/efi.nix

#     ./../Users/hacktheegg.nix


    ./../Modules
  ];

  omelette.boot.efi.enable = true;

  age.secrets.tunnel-token-practice-server.file = ../Secrets/Tunnel-Token-Practice-Server.age;

  omelette.containers.jellyfin = {
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
  omelette.containers.reverse-proxy = {
    enable = true;
    cloudflared = {
      enable = true;
      token = config.age.secrets.tunnel-token-practice-server.path;
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

  age.secrets.tunnel-cloudflare-server.file = ./../Secrets/tunnel-cloudflare-server.age;

  services.cloudflared = {
    enable = true;
    tunnels = {
      "77fa5c8f-bf8c-4102-8d4a-a73a6936fd18" = {
        credentialsFile = config.age.secrets.tunnel-cloudflare-server.path;
        ingress = {
          "ssh-practice-server.hacktheegg.cc" = "ssh://localhost:22";
        };

        default = "http_status:404";
      };
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




  age.secrets.copyparty-pass = {
    file = ./../Secrets/test-secret.age;
    owner = "hacktheegg";
    group = "users";
  };


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
      accounts.hacktheegg.passwordFile = config.age.secrets.copyparty-pass.path;


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
