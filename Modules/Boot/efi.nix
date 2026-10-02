{ config, lib, ... }:
{
  options.omelette.boot.efi = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Enable EFI boot method.";
    };
    useOSProber = lib.mkEnableOption "Use os prober";
  };
  config = lib.mkIf config.omelette.boot.efi.enable {
    boot.loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        device = "nodev";
        efiSupport = true;
        useOSProber = config.omelette.boot.efi.useOSProber;
        enable = true;
      };
      systemd-boot.enable = false;
    };
  };
}
