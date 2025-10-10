{
  config,
  lib,
  ...
}: let
  wayland = config.local.home.desktop.wlr;
  cfg = wayland.fnott;
in {
  options.local.home.desktop.wlr.fnott = {
    enable = lib.mkEnableOption "Enable fnott configuration";
  };
  config = lib.mkIf cfg.enable {
    #TODO add more options
    services.fnott = {
      enable = true;
      settings = {
        main = {
          notification-margin = 5;
          default-timeout = 5;
          anchor = "top-left";
          min-width = 360;
          max-width = 360;
        };
      };
    };
  };
}
