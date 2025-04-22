{
  config,
  lib,
  ...
}: let
  cfg = config.local.desktop;
in {
  options.local.desktop.enablePams = lib.mkEnableOption "Enable desktop root configuration";
  config = lib.mkIf cfg.enablePams {
    security.pam.services.waylock = {};
    security.pam.services.hyprlock = {};
  };
  imports = [
    ./graphics.nix
    ./hyprland.nix
    ./nvidia.nix
    ./plasma.nix
    ./riverwm.nix
    ./wireshark.nix
  ];
}
