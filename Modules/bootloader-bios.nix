{ ... }:

{
  boot.loader = {
    #efi.canTouchEfiVariables = true;
    grub = {
      device = "/dev/sda";
      #efiSupport = true;
      enable = true;
    };
    systemd-boot.enable = false;
  };

  systemd.settings.Manager = {
    DefaultNoNewPrivileges=true;
  };
  #systemd.user.extraConfig = "DefaultNoNewPrivileges=true";

}
