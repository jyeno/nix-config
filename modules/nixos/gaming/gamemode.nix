{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.gaming.gamemode;
in {
  options.local.gaming.gamemode = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable gamemode configuration";
    };
    enableNotifications = lib.mkEnableOption "Enable notifications on the startup and end of execution";
  };
  config = lib.mkIf cfg.enable {
    programs.gamemode = {
      enable = lib.mkDefault true;
      enableRenice = lib.mkDefault true;
      settings = {
        # TODO change to be more lib-y
        general = {
          desiredgov = "performance";
          reaper_freq = 3;
          renice = 4;
          softrealtime = "on";
          inhibit_screensaver = 1;
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          amd_performance_level = "high";
        };
        cpu = {
          park_cores = "no";
          pin_cores = "yes";
        };
        custom = lib.mkIf cfg.enableNotifications {
          start = lib.mkDefault "${pkgs.libnotify}/bin/notify-send 'GameMode Started'";
          end = lib.mkDefault "${pkgs.libnotify}/bin/notify-send 'GameMode Ended'";
        };
      };
    };
  };
}
