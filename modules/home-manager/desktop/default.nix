{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.home.desktop;
in {
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
    cursorTheme = {
      size = lib.mkOption {
        type = lib.types.int;
        default = 24;
        description = "cursor size configuration";
      };
      name = lib.mkOption {
        type = lib.types.str;
        default = "breeze_cursors";
        description = "cursor name configuration";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.kdePackages.breeze;
        description = "cursor package configuration";
      };
    };
    theme = {
      stylix = lib.mkOption {
        type = with lib; types.nullOr (types.attrsOf types.anything);
        default = null;
        description = "stylix configuration";
      };
      name = lib.mkOption {
        type = lib.types.str;
        default = "Breeze";
        description = "theme name configuration";
      };
      iconName = lib.mkOption {
        type = lib.types.str;
        default = "breeze-dark";
        description = "icon theme name configuration";
      };
      gtk = {
        themeName = lib.mkOption {
          type = lib.types.str;
          default = "breeze-dark";
          description = "gtk theme name configuration";
        };
        preferDarkTheme = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "gtk prefer dark theme configuration";
        };
        decorationLayout = lib.mkOption {
          type = lib.types.str;
          default = "icon:minimize,maximize,close";
          description = "gtk decoration layout configuration";
        };
      };
    };
  };
  config = {
    stylix = lib.optionals (cfg.theme.stylix != null) cfg.theme.stylix;
    home.pointerCursor = {
      x11.enable = lib.mkDefault true;
      name = cfg.cursorTheme.name;
      size = cfg.cursorTheme.size;
      package = cfg.cursorTheme.package;
    };
    gtk = {
      enable = true;
      theme.name = lib.mkDefault cfg.theme.gtk.themeName;
      iconTheme.name = cfg.theme.iconName;
      cursorTheme = {
        name = cfg.cursorTheme.name;
        size = cfg.cursorTheme.size;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = cfg.theme.gtk.preferDarkTheme;
        gtk-decoration-layout = cfg.theme.gtk.decorationLayout;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = cfg.theme.gtk.preferDarkTheme;
        gtk-decoration-layout = cfg.theme.gtk.decorationLayout;
      };
    };
  };
}
