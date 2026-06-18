{ ... }:

{

  programs.librewolf = {
    enable = true;
    profiles = {
      "Original" = {
        isDefault = true;
        extensions = {
          # Get them yourself
          # UBlock Origin
          # NoScript
          # Floccus Bookmarks Sync
          # Indie Wiki Buddy
          # Ruffle - Flash Emulator
        };
        search.engines = {
          nixos-wiki = {
            name = "SearXNG";
            urls = [{ template = "https://searxng.hacktheegg.cc/search?q={searchTerms}&category_general=1&language=auto&time_range=&safesearch=0&theme=simple"; }];
            iconMapObj."16" = "https://searxng.hacktheegg.cc/favicon.ico";
            definedAliases = [ "@srx" ];
          };
          default = "srx";
          privateDefault = "srx";

        };
        settings = {
          "sidebar.verticalTabs" =                          "true";
          "sidebar.verticalTabs.dragToPinPromo.dismissed" = "true";
        };
      };
      "I2P" = {
        extensions = {
          # Get them yourself
          # UBlock Origin
          # NoScript
        };

        settings = {
          "browser.contentblocking.category" =    "strict";
          "dom.security.https_only_mode" =        "false";
          "javascript.enabled" =                  "false";
          "keyword.enabled" =                     "false";
          "network.proxy.backup.ssl" =            "172.0.0.1";
          "network.proxy.backup.ssl_port" =       "4444";
          "network.proxy.http" =                  "127.0.0.1";
          "network.proxy.http_port" =             "4444";
          "network.proxy.share_proxy_settings" =  "true";
          "network.proxy.socks" =                 "127.0.0.1";
          "network.proxy.socks_port" =            "4447";
          "network.proxy.ssl" =                   "127.0.0.1";
          "network.proxy.ssl_port" =              "4444";
          "network.proxy.type" =                  "1";
        };
      };
    };
  };
}
