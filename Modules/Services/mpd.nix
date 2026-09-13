{ config, lib, ... }:


{
  options.omelette.services.mpd = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Whether to enable mpd.";
    };
  };


  config = lib.mkIf config.omelette.services.mpd.enable {
    services.mpd = {
      enable = true;
      settings = {
        music_directory = "/path/to/music";
      };
      network.listenAddress = "any";
    };
  };
}
