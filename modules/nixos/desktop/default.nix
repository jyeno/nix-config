{
  config,
  lib,
  ...
}: let
  cfg = config.local.desktop;
in {
  options.local.desktop = {
    enablePams = lib.mkEnableOption "Enable desktop root configuration";
    stylix = lib.mkOption {
      type = with lib; types.nullOr (types.attrsOf types.anything);
      default = null;
      description = "stylix configuration";
    };
  };
  config = {
    security.pam.services = lib.mkIf cfg.enablePams {
      waylock = {};
      hyprlock = {};
    };
    stylix = lib.optionals (cfg.stylix != null) cfg.stylix;
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
