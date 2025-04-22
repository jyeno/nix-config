{
  config,
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
  };

  # programs.uwsm = {
  #   enable = true;
  #   waylandCompositors = {
  #     hyprland = {
  #       prettyName = "Hyprland";
  #       comment = "Hyprland compositor managed by UWSM";
  #       binPath = "/run/current-system/sw/bin/Hyprland";
  #     };
  #   };
  # };

  # xdg.portal = {
  #   enable = true;
  #   wlr.enable = true;
  #   xdgOpenUsePortal = true;
  #   extraPortals = [
  #     pkgs.xdg-desktop-portal-hyprland
  #     pkgs.xdg-desktop-portal-gtk
  #   ];
  # };
}
