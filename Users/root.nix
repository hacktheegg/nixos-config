{ ... }:

{

  home-manager.users = {
    root = {
      home.stateVersion = "25.11";
      programs = {
        git = {
          enable = true;
          # Global root config to stop the GUI popups
          settings = {
            core.askpass = "";
            safe.directory = "/etc/nixos";
          };

          # Domain-specific credential helper
          # We use 'cut' to grab everything after the '=' sign
          settings = {
            "credential \"https://git.hacktheegg.cc\"" = {
              helper = "!f() { echo \"password=$(cat /run/agenix/forgejo-token | cut -d'=' -f2)\"; }; f";
            };
          };
        };
      };
    };
  };


}
