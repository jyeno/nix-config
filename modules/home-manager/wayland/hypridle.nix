{
  config,
  lib,
  pkgs,
  ...
}: let
  wayland = config.local.home.wayland;
  cfg = wayland.hypridle;
in {
  options.local.home.wayland.hypridle = {
    enable = lib.mkEnableOption "Enable hypridle configuration";
  };
  config = lib.mkIf cfg.enable {
    # TODO add more options, revamp code
    services.hypridle = {
      enable = true;
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
}
