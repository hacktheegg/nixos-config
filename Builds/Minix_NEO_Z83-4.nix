{ ... }:

{

  imports =
    [

      ./../Modules/bootloader.nix

      # Verify Before Adding
      #./../Modules/git.nix
      #./../Modules/mpd.nix

      ./../Users/root.nix
    ];

  system.stateVersion = "25.11";

}
