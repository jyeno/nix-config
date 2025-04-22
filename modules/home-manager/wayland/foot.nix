{
  config,
  lib,
  pkgs,
  ...
}: let
  wayland = config.local.home.wayland;
  cfg = wayland.foot;
in {
  options.local.home.wayland.foot = {
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
          font = "JetBrainsMono Nerd Font:size=11";
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

        colors = {
          foreground = "cccccc"; #white
          background = "2d2d2d"; # black
          regular0 = "2d2d2d"; # black
          regular1 = "f2777a"; # red
          regular2 = "99cc99"; # green
          regular3 = "ffcc66"; # yellow
          regular4 = "6699cc"; # blue
          regular5 = "cc99cc"; # magenta
          regular6 = "66cccc"; # cyan
          regular7 = "cccccc"; # white
          bright0 = "999999"; # bright black
          bright1 = "f2777a"; # bright red
          bright2 = "99cc99"; # bright green
          bright3 = "ffcc66"; # bright yellow
          bright4 = "6699cc"; # bright blue
          bright5 = "cc99cc"; # bright magenta
          bright6 = "66cccc"; # bright cyan
          bright7 = "ffffff"; # bright white
        };

        cursor = {
          style = "underline";
          blink = "yes";
        };
      };
    };
  };
}
