{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.tweaks.fonts;
in {
  options.local.tweaks.fonts.enable = lib.mkEnableOption "Enable font configuration";
  config = lib.mkIf cfg.enable {
    environment.variables = {
      FREETYPE_PROPERTIES = lib.concatStringsSep " " [
        "truetype:interpreter-version=38"
        "autofitter:warping=1"
        "autofitter:no-stem-darkening=0"
        "cff:no-stem-darkening=0"
        "t1cid:no-stem-darkening=0"
        "type1:no-stem-darkening=0"
      ];
    };

    #TODO see infinality
    fonts = {
      packages = lib.mkDefault [
        pkgs.noto-fonts
        pkgs.noto-fonts-cjk-sans
        pkgs.noto-fonts-emoji
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.source-han-sans
        pkgs.jost
        pkgs.liberation_ttf
      ];
      # defaultFonts = {
      #   monospace = ["JetBrainsMono Nerd Font"];
      #   serif = ["Noto Serif" "Source Han Serif"];
      #   sansSerif = ["Noto Sans" "Source Han Sans"];
      # };
      fontconfig = {
        antialias = lib.mkDefault true;
        hinting = {
          enable = lib.mkDefault true;
          style = lib.mkDefault "slight";
        };
        subpixel = {
          lcdfilter = lib.mkDefault "none";
          rgba = lib.mkDefault "none";
        };
      };
    };
  };
}
