{ pkgs, ... }:

{
  home = rec {
    sessionVariables = {
#       PASSWORD_STORE_DIR  = ;
    };
    packages = with pkgs; [
      pass
      qtpass
    ];
  };

  services.pass-secret-service = {
    enable = false;
    storePath = "/home/password-store";
  };
}
