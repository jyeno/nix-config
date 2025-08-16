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
  };
  config = lib.mkIf (cfg.enable) {
    security.pam.services = lib.mkIf cfg.enablePams {
      waylock = {};
      hyprlock = {};
    };
  };
}
