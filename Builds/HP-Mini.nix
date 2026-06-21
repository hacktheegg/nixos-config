{ ... }:

{

  imports =
    [
      ./../Hardware/HP-Mini.nix

      ./../Modules/bootloader-bios.nix

      #./../Users/root.nix
    ];

  system.stateVersion = "25.11";

}
