{ config, lib, ... }:
{
  options.omelette.boot.bios = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Enable BIOS boot method.";
    };
  };
  config = lib.mkIf config.omelette.boot.bios.enable {
    boot.loader = {
      grub = {
        device = throw "YOUR DEVICE IS USING BIOS BOOT, SO CHECK YOURSELF WHAT NEEDS TO BE DONE IN ./Modules/bootloader-bios.nix";
        enable = true;
      };
      systemd-boot.enable = false;
    };
  };
}
