{ pkgs, ... }:

{
  qt = {
    enable = true;

    platformTheme.name = "kde";
    style.name = "breeze";

    kde.settings = {
      kdeglobals = {
        General = {
          ColorScheme = "BreezeDark";
        };

        KDE = {
          widgetStyle = "Breeze";
        };

        Icons = {
          Theme = "Breeze Dark";
        };

      };
    };
  };

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "kde";
  };

  home.packages = with pkgs; [
    kdePackages.breeze
    kdePackages.breeze-icons
  ];
}
