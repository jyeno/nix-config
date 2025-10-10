{
  config,
  lib,
  ...
}: let
  wayland = config.local.home.desktop.wlr;
  cfg = wayland.hyprlock;
in {
  options.local.home.desktop.wlr.hyprlock = {
    enable = lib.mkEnableOption "Enable hyprlock configuration";
  };
  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          ignore_empty_input = true;
          hide_cursor = true;
        };
        animations = {
          enabled = true;
          fade_in = {
            duration = 300;
            bezier = "easeOutQuint";
          };
          fade_out = {
            duration = 300;
            bezier = "easeOutQuint";
          };
        };
      };
    };
  };
}
