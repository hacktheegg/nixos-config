{ config, lib, ... }:
{
  options.omelette.boot.bios = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Enable BIOS boot method.";
    };
    device = lib.mkOption {
      type = lib.types.str;
#       default = false;
      example = "/dev/sda";
      description = "Device to install GRUB bootloader onto.";
    };
    useOSProber = lib.mkEnableOption "Use os prober";
  };
  config = lib.mkIf config.omelette.boot.bios.enable {
    boot.loader = {
      grub = {
        device = config.omelette.boot.bios.device;
        useOSProber = config.omelette.boot.bios.useOSProber;
        enable = true;
      };
      systemd-boot.enable = false;
    };
  };
}
