{ pkgs, nur, ... }:

{

#   nixpkgs.config = {
# #     permittedInsecurePackages = [
# #       "librewolf-151.0.2-1"
# #       "librewolf-unwrapped-151.0.2-1"
# #     ];
#     packageOverrides = pkgs: {
#       nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/main.tar.gz") {
#         inherit pkgs;
#       };
#     };
#   };



  programs.librewolf = {
    enable = true;
    profiles = {
      "Original" = {
        isDefault = true;
        id = 0;
        extensions.packages = with nur.repos.rycee.firefox-addons; [
          ublock-origin
          noscript
          floccus
          indie-wiki-buddy
          ruffle_rs
          keepassxc-browser
          # Get them yourself
          # UBlock Origin
          # NoScript
          # Floccus Bookmarks Sync
          # Indie Wiki Buddy
          # Ruffle - Flash Emulator
        ];
        search = {
          force = true;
          engines = {
            searxng = {
              name = "SearXNG";
              urls = [{ template = "https://searxng.hacktheegg.cc/search?q={searchTerms}&category_general=1&language=auto&time_range=&safesearch=0&theme=simple"; }];
              iconMapObj."16" = "https://searxng.hacktheegg.cc/favicon.ico";
              definedAliases = [ "@srx" ];
            };
          };
          default = "srx";
          privateDefault = "srx";

        };
        settings = {
          "sidebar.verticalTabs" =                          true;
          "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;

#           "browser.search.defaultenginename" =              "SearXNG";
#           "browser.search.order.1" =                        "SearXNG";
        };
      };
      "I2P" = {
        isDefault = false;
        id = 1;
        extensions.packages = with nur.repos.rycee.firefox-addons; [
          ublock-origin
          noscript
          # Get them yourself
          # UBlock Origin
          # NoScript
        ];

        settings = {
          "browser.contentblocking.category" =    "strict";
          "dom.security.https_only_mode" =        false;
          "javascript.enabled" =                  false;
          "keyword.enabled" =                     false;
          "network.proxy.backup.ssl" =            "127.0.0.1";
          "network.proxy.backup.ssl_port" =       4444;
          "network.proxy.http" =                  "127.0.0.1";
          "network.proxy.http_port" =             4444;
          "network.proxy.share_proxy_settings" =  "true";
          "network.proxy.socks" =                 "127.0.0.1";
          "network.proxy.socks_port" =            4447;
          "network.proxy.ssl" =                   "127.0.0.1";
          "network.proxy.ssl_port" =              4444;
          "network.proxy.type" =                  1;
        };
      };
    };
  };

  xdg.desktopEntries.librewolf-i2p = {
    name = "LibreWolf (I2P)";
    genericName = "Web Browser";

    exec = "${pkgs.librewolf}/bin/librewolf --name librewolf-i2p -P I2P -no-remote %U";

    icon = "librewolf";

    terminal = false;
    startupNotify = true;

    categories = [ "Network" "WebBrowser" ];

    mimeType = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];

    settings = {
      StartupWMClass = "librewolf-i2p";
      Actions = "new-private-window;new-window";
    };

    actions = {
      new-window = {
        name = "New Window";
        exec = "${pkgs.librewolf}/bin/librewolf --name librewolf-i2p -P I2P -no-remote --new-window %U";
      };

      new-private-window = {
        name = "New Private Window";
        exec = "${pkgs.librewolf}/bin/librewolf --name librewolf-i2p -P I2P -no-remote --private-window %U";
      };
    };
  };
}
