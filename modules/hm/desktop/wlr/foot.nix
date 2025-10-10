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
    systemd.user.services.foot.Service.Environment = ["PATH=/run/current-system/sw/bin/"];

    programs.foot = {
      enable = true;
      server.enable = true;

      settings = let
        fish = lib.getExe pkgs.fish;
        notify-send = lib.getExe' pkgs.libnotify "notify-send";
        xdg-open = lib.getExe' pkgs.xdg-utils "xdg-open";
      in {
        main = {
          term = "foot";
          shell = "${fish}";
          # pad = "15x15";
          notify = "${notify-send} -a \${app-id} -i \${app-id} \${title} \${body}";
          selection-target = "clipboard";
        };

        scrollback = {
          lines = 100000;
          multiplier = 3;
        };

        url = {
          launch = "${xdg-open} \${url}";
          label-letters = "sadfjklewcmpgh";
          osc8-underline = "url-mode";
          protocols = "http, https, ftp, ftps, file";
          uri-characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+=\"'()[]";
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
