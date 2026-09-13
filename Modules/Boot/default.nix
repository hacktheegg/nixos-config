{ config, lib, ... }:
{

  imports = [
    ./bios.nix
    ./efi.nix
  ];

  config = {
    assertions = [
      {
        assertion = !(config.omelette.boot.bios.enable && config.omelette.boot.efi.enable);
        message = "You cannot enable both BIOS and EFI boot configurations simultaneously!";
      }
    ];
  };
}
