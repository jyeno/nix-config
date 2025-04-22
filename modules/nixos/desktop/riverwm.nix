{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.desktop.river;
in {
  options.local.desktop.river.enable = lib.mkEnableOption "Enable river configuration";
  config = lib.mkIf cfg.enable {
    programs.river.enable = true;

    programs.light.enable = true;

    services.seatd.enable = true;

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
}
