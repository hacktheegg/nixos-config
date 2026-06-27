{ pkgs, ... }:

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


}
