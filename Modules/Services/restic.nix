{ config, lib, ... }:

let
  cfg = config.omelette.services.restic;
in
{
  options.omelette.services.restic = {
    enable = lib.mkEnableOption "Restic Backups";
  };

  config = lib.mkIf cfg.enable {
    services.restic.backups.home-backup = {
      paths = [ "/home/hacktheegg" ];

      repository = "rest:https://restic.hacktheegg.cc/hacktheegg";

      passwordFile = "/run/agenix/restic-repo-password";

      environmentFile = "/run/agenix/restic-env";

      initialize = true;

      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };

      extraBackupArgs = [
        "--exclude='.cache'"
        "--exclude='.hist'"
        "--exclude='.local/share/Steam'"
        "--exclude='.local/share/waydroid'"
      ];
    };
  };
}
