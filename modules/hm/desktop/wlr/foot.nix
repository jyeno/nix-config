{
  config,
  lib,
  pkgs,
  ...
}: let
  wayland = config.local.home.desktop.wlr;
  cfg = wayland.foot;
in {
  options.local.home.desktop.wlr.foot = {
    enable = lib.mkEnableOption "Enable foot configuration";
  };
  config = lib.mkIf cfg.enable {
    # fix to run footclient
    #TODO add more options
    # systemd.user.services.foot.Service.Environment = ["PATH=/run/current-system/sw/bin/"];

    programs.foot = {
      enable = true;
      server.enable = true;

      settings = {
        main = {
          term = "xterm-256color";
          selection-target = "clipboard";
        };

        scrollback = {
          lines = 100000;
          multiplier = 3;
        };

        mouse.hide-when-typing = "yes";

        cursor = {
          style = "underline";
          blink = "yes";
        };
      };
    };
  };
}
