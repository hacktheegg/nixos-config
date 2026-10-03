{ config, pkgs, lib, ... }:

let
  cfg = config.omelette.services.update-alert;
in
{
  options.omelette.services.update-alert = {
    enable = lib.mkEnableOption "NTFY Update Alerter (when behind)";
    url = lib.mkOption {
      type = lib.types.str;
#       default = null;
      example = "/run/agenix/secret1";
      description = ''
        Path to file containing NTFY url. (REQUIRED: AGENIX)"
        -- Content Format --
        ntfy.domain.com/category
      '';
    };
    credentials = lib.mkOption {
      type = lib.types.str;
#       default = null;
      example = "/run/agenix/secret1";
      description = ''
        Path to file containing NTFY credentials. (REQUIRED: AGENIX)"
        -- Content Format --
        username:password
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.update-alert = {
    description = "Periodically Alert NTFY When Device is Behind in Version.";
    path = [
      pkgs.git
      pkgs.coreutils
      pkgs.gnugrep
      pkgs.ntfy-sh
      pkgs._9base
      pkgs.hostname
    ];

    enable = true;
    startAt = "daily";

    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      Restart = "on-failure";
      RestartSec = "5s";
      WorkingDirectory = "/etc/nixos";
      User = "nobody";
    };

    script = ''
      set -eu

      sleep 60
      sleep 60
      sleep 60
      sleep 60
      sleep 60

      GIT_REVISION_LOCAL="$(git -c safe.directory=/etc/nixos rev-parse HEAD)"
      GIT_REVISION_REMOTE="$(git ls-remote https://git.hacktheegg.cc/hacktheegg/nixos-config.git HEAD | cut -f1)"

      NTFY_USER="$(cat ${cfg.credentials})"
      NTFY_URL="$(cat ${cfg.url})"

      if [ "$GIT_REVISION_LOCAL" != "$GIT_REVISION_REMOTE" ] ; then
        echo "commits don\'t match up"
        ntfy pub -u "$NTFY_USER" "$NTFY_URL" "$(${pkgs.hostname}/bin/hostname) is Out of Date"
      else
        echo "no update needed"
      fi
    '';
  };

  };
}
