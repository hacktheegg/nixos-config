{ ... }:

{
  programs.keepassxc = {
    autostart = true;
    enable = true;
    settings = {
      FdoSecrets.Enabled = true;
      Browser = {
        AllowExpiredCredentials = true;
      };
    };
  };

  xdg.autostart.enable = true;

}
