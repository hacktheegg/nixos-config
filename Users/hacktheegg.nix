{ ... }:

{

  users.users.hacktheegg = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "input"
      "audio"
      "libvirtd"
      "video"
      "render"
      "docker"
      "kvm"
      "wheel"
    ];
    initialPassword = "abc";
    home = "/home/hacktheegg";
  };

#   home-manager.users = {
#     hacktheegg =
#       {
#         config,
#         pkgs,
#         nur,
#         ...
#       }:
#       {
#         home.stateVersion = "25.11";
# #         imports = [
# #           ./dark-mode-GTK.nix
# #           ./dark-mode-QT.nix
# #           #         ./dark-mode-KDE.nix
# #         ]
# #         ++ (if builtins.pathExists /home/hacktheegg/home.nix then [ /home/hacktheegg/home.nix ] else [ ]);
#
#
#
#       };
#   };

}
