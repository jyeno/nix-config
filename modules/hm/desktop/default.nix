{
  config,
  lib,
  localLib,
  ...
}: let
  cfg = config.local.home.desktop;
in {
  # imports = lib.attrsets.attrValues (localLib.discoverModules ./.);
  imports = [
    ./chromium.nix
    ./cliphist.nix
    ./firefox.nix
    ./ghostty.nix
    ./zathura.nix
    ./plasma.nix
    ./hyprland.nix
    ./riverwm.nix
  ];

  options.local.home.desktop = {
    enable = lib.mkEnableOption "Enable desktop settingss";
    stylix = lib.mkOption {
      type = with lib.types; attrsOf types.anything;
      default = {};
      description = "stylix configuration";
    };
  };
  config = lib.mkIf (cfg.enable && cfg.stylix != {}) {
    stylix = cfg.stylix;
  };
}
