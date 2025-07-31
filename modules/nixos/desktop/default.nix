{
  config,
  lib,
  localLib,
  ...
}: let
  cfg = config.local.desktop;
in {
  imports = lib.attrsets.attrValues (localLib.discoverModules ./.);

  options.local.desktop = {
    enable = lib.mkEnableOption "Enable desktop settings";
    enablePams = lib.mkEnableOption "Enable desktop root configuration";
    stylix = lib.mkOption {
      type = with lib; types.nullOr (types.attrsOf types.anything);
      default = null;
      description = "stylix configuration";
    };
  };
  config = lib.mkIf cfg.enable {
    stylix = lib.optionals (cfg.stylix != null) cfg.stylix;
    security.pam.services = lib.mkIf cfg.enablePams {
      waylock = {};
      hyprlock = {};
    };
  };
}
