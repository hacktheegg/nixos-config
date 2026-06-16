{ config, ... }:

let

  copyparty = fetchTarball "https://github.com/9001/copyparty/archive/hovudstraum.tar.gz";

in

{

  imports = [
    <agenix/modules/age.nix>
    "${copyparty}/contrib/nixos/modules/copyparty.nix"
  ];

  nixpkgs.overlays = [
    (import "${copyparty}/contrib/package/nix/overlay.nix")
  ];

  age.secrets.copyparty-hacktheegg =  {
    file = ./../Secrets/copyparty-hacktheegg.age;
    owner = "hacktheegg";        # Give the copyparty user ownership
    group = "users";             # Optional: set the group as well
    mode = "0440";               # Keep it strictly readable by that user only
  };

  age.identityPaths = [
    "/root/.ssh/id_ed25519"
  ];

  networking.firewall.allowedTCPPorts = [ 3923 ];




  systemd.services.copyparty = {
    serviceConfig = {

      TimeoutStopSec = "10s";
      # 1. Resource Hard Caps
      # Limits total CPU time to 25% of one core
      CPUQuota = "25%";
      # Limits RAM to 25% of total system memory (e.g., 2GB on an 8GB RAM T460)
      MemoryMax = "25%";
      MemoryHigh = "20%"; # Throttles the process before it hits the Max limit

      # 2. "First to Die" Settings (OOM Protection)
      # OOMScoreAdjust goes from -1000 (never kill) to 1000 (kill first)
      OOMScoreAdjust = 1000;
      # Tells systemd to kill the service immediately if it hits MemoryMax
      OOMPolicy = "kill";

      # 3. Background Priority (The "Nice" factor)
      # 19 is the lowest priority; it only gets CPU cycles if nothing else wants them
      Nice = 19;
      # Reduces disk I/O priority so your UI doesn't lag during file indexing
      IOSchedulingClass = "idle";
      IOSchedulingPriority = 7;

    };
  };





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
      accounts.hacktheegg.passwordFile = config.age.secrets.copyparty-hacktheegg.path;


      volumes."/" = {
        path = "/home/hacktheegg";
        access.rwmda = [ "hacktheegg" ];
        flags = {
          d2d = true;
          d2t = true;
          noidx = "/.local/share/Steam,/.cache";
          nohash = "/.local/share/Steam,/.cache";
        };
      };
      volumes."/Shared" = {
        path = "/home/hacktheegg/Downloads/Copyparty";
        access.rwmd = [ "*" ];
        flags = {
          d2d = true;
          d2t = true;
        };
      };
    };
  };



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
