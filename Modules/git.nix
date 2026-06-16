{ pkgs, ... }:

{
  programs = {
    git = {
      enable = true;
      config = [{
        init = {
          defaultBranch = "main";
        };
        user.name = "hacktheegg";
        user.email = "hacktheegg@hacktheegg.cc";
      }];
    };
  };

  age.secrets.forgejo-token.file = ./../Secrets/forgejo-token.age;

  systemd.services.nixos-git-backup = {
    description = "Push NixOS config to Forgejo";
    path = [ pkgs.git pkgs.coreutils pkgs.gnugrep ];
 
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      WorkingDirectory = "/etc/nixos";
      # This loads the decrypted age secret as environment variables
      # Format of the decrypted file should be: FORGEJO_TOKEN=your_token_here
      EnvironmentFile = "/run/agenix/forgejo-token";
    };

    script = ''
      export HOME=/root
      git config --global safe.directory /etc/nixos

      git add .

      # Check if there are changes to commit
      if ! git diff-index --quiet HEAD --; then
        git commit -m "Auto-sync $(date)"
        # Use the variable loaded from the age secret
        git push https://$FORGEJO_TOKEN@git.hacktheegg.cc/hacktheegg/nixos-config.git main
      else
        echo "No changes to commit."
      fi
    '';

    startAt = "daily";
  };

  environment.sessionVariables = rec {
    PASSWORD_STORE_DIR  = "/home/password-store";
  };
  
  environment.systemPackages = with pkgs; [
    pass
    qtpass
  ];

  programs.gnupg = {
    #enable = true;
    agent = {
      enable = true;
      enableSSHSupport = true;
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
