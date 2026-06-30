{ pkgs, ... }:

{

  security.polkit.enable = true;

#   systemd.user.services.lxqt-policykit-agent = {
#     description = "LXQt PolicyKit Authentication Agent";
#     wantedBy = [ "graphical-session.target" ];
#     serviceConfig = {
#       ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
#       Restart = "on-failure";
#     };
#   };

}
