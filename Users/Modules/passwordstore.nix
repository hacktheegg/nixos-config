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
    enable = true;
    storePath = "/home/password-store";
  };
}
