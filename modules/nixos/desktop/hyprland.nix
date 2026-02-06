{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.local.desktop.hyprland;
in {
  options.local.desktop.hyprland.enable = lib.mkEnableOption "Enable Hyprland configuration";
  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = lib.mkDefault true;
    };
    programs.light.enable = true;

    services.seatd.enable = true;

    # xdg.portal = {
    #   enable = true;
    #   xdgOpenUsePortal = true;
    #   config = {
    # common.default = ["gtk"];
    # hyprland.default = [
    #   "gtk"
    #   "hyprland"
    # ];
    # };

    # extraPortals = [pkgs.xdg-desktop-portal-gtk];
    # };
  };
}
