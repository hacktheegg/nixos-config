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
    enable = false;
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

}
