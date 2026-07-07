{ ... }:

{
  programs.keepassxc = {
    autostart = true;
    enable = true;
    settings = {
      FdoSecrets.Enabled = true;
      Browser = {
        Enabled = true;
        AllowExpiredCredentials = true;
      };
    };
  };

  xdg.autostart.enable = true;

}
