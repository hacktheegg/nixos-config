{ ... }:

{

  imports = [
    <home-manager/nixos>
  ];

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
