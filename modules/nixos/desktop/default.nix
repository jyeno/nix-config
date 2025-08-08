{
  config,
  lib,
  localLib,
  ...
}: let
  cfg = config.local.desktop;
in {
  # imports = lib.attrsets.attrValues (localLib.discoverModules ./.);
  imports = [
    ./graphics.nix
    ./hyprland.nix
    ./nvidia.nix
    ./plasma.nix
    ./riverwm.nix
    ./wireshark.nix
  ];

  options.local.desktop = {
    enable = lib.mkEnableOption "Enable desktop settings";
    enablePams = lib.mkEnableOption "Enable desktop root configuration";
    stylix = lib.mkOption {
      type = with lib.types; attrsOf anything;
      default = {};
      description = "stylix configuration";
    };
  };
  config = lib.mkIf (cfg.enable && cfg.stylix != {}) {
    security.pam.services = lib.mkIf cfg.enablePams {
      waylock = {};
      hyprlock = {};
    };
    stylix = cfg.stylix;
  };
}
