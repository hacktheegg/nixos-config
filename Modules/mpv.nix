{ config, lib, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    mpv
  ];

  nixpkgs.overlays = [

    (self: super: {
      mpv = super.mpv.override {
        scripts = [
          #self.mpvScripts.mpris # Official script

          # Custom script from GitHub
          (self.stdenv.mkDerivation {
            pname = "mpv-file-browser";
            version = "latest";

            src = self.fetchFromGitHub {
              owner = "CogentRedTester";
              repo = "mpv-file-browser";
              rev = "c9f06f90f95444585ef02aa7a82ca10ff9e50db1"; # Or a specific commit/tag
              sha256 = "sha256-Rm34CT41wFZqaZ3I012/6HnjCGqyPWkcZyf/aQ8rb+A=";
            };

            dontBuild = true;

            installPhase = ''
              mkdir -p $out/share/mpv/scripts/file-browser
              cp -r * $out/share/mpv/scripts/file-browser
            '';

            # The wrapper needs this to know the entry point or directory name
            passthru.scriptName = "file-browser";
          })
        ];
      };
    })
  ];


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
