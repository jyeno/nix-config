{
  config,
  lib,
  ...
}: let
  cfg = config.local.home.desktop.wlr.ashell;
in {
  options.local.home.desktop.wlr.ashell = {
    enable = lib.mkEnableOption "Enable ashell configuration";
    target = lib.mkOption {
      type = lib.types.str;
      default = "hyprland-session.target"; # wayland-session
      description = "target wayland session";
    };
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "ashell config settings";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.ashell = {
      enable = true;
      systemd = {
        enable = lib.mkDefault true;
        inherit (cfg) target;
      };
      inherit (cfg) settings;
    };
  };
}
