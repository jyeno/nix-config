{
  flake.modules.nixos.cli-fonts =
    {
      pkgs,
      lib,
      ...
    }:
    {
      #TODO test if necessary/valid
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

      fonts = {
        packages = [
          pkgs.noto-fonts
          pkgs.noto-fonts-cjk-sans
          pkgs.noto-fonts-color-emoji
          pkgs.jost
          pkgs.liberation_ttf
        ];
        # defaultFonts = {
        #   monospace = ["JetBrainsMono Nerd Font"];
        #   serif = ["Noto Serif" "Source Han Serif"];
        #   sansSerif = ["Noto Sans" "Source Han Sans"];
        # };
        fontconfig = {
          antialias = true;
          hinting = {
            enable = true;
            style = "slight";
          };
          subpixel = {
            lcdfilter = "none";
            rgba = "none";
          };
        };
      };
    };
}
