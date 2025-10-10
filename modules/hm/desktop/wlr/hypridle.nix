{
  config,
  lib,
  pkgs,
  ...
}: let
  wayland = config.local.home.desktop.wlr;
  cfg = wayland.hypridle;
in {
  options.local.home.desktop.wlr.hypridle = {
    enable = lib.mkEnableOption "Enable hypridle configuration";
    target = lib.mkOption {
      type = lib.types.str;
      default = "hyprland-session.target";
      description = "target wayland session";
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      hyprsunset = {
        enable = true;
        systemdTarget = cfg.target;
        settings = {
          max-gamma = 150;

          profile = [
            {
              time = "7:30";
              identity = true;
            }
            {
              time = "19:30";
              temperature = 5000;
              gamma = 0.8;
            }
          ];
        };
      };
      hypridle = {
        enable = true;
        systemdTarget = cfg.target;
        settings = let
          hyprctl = lib.getExe' pkgs.hyprland "hyprctl";
          wlopm = lib.getExe pkgs.wlopm;
          isRiverEnabled = config.wayland.windowManager.river.enable;
          dpms-on =
            if isRiverEnabled
            then "${wlopm} --on DP-1"
            else "${hyprctl} dispatch dpms on"; # change it so it depends on what wayland compositor is being used
          dpms-off =
            if isRiverEnabled
            then "${wlopm} --off DP-1"
            else "${hyprctl} dispatch dpms off"; # change it so it depends on what wayland compositor is being used
          locker = lib.getExe (
            if isRiverEnabled
            then pkgs.waylock
            else pkgs.hyprlock
          );
          lock-cmd = "pidof ${locker} || ${locker} -fork-on-lock";
        in {
          general = {
            after_sleep_cmd = dpms-on;
            ignore_dbus_inhibit = false;
            lock_cmd = lock-cmd;
          };

          listener = [
            {
              timeout = 600;
              on-timeout = "${locker} -fork-on-lock";
            }
            {
              timeout = 630;
              on-timeout = dpms-off;
              on-resume = dpms-on;
            }
            {
              timeout = 1200;
              on-timeout = "systemctl suspend";
            }
          ];
        };
      };
    };
  };
}
