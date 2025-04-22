{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.home.wayland;
in {
  options.local.home.wayland = {
    #TODO I dont know
    enable = lib.mkEnableOption "Enable wayland user configuration files";
    imv.enable = lib.mkEnableOption "Enable imv";
    theme = {
      cursorSize = lib.mkOption {
        type = lib.types.int;
        default = 18;
        description = "Set cursor size";
      };
    };
  };

  imports = [
    ./ashell.nix
    ./cliphist.nix
    ./fnott.nix
    ./foot.nix
    ./gbar.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./riverwm.nix
    ./waybar.nix
    ./wofi.nix
    ./yambar.nix
  ];

  config = lib.mkIf cfg.enable {
    programs.imv.enable = cfg.imv.enable;

    #TODO add more options
    gtk = {
      enable = lib.mkDefault true;
      theme = {
        name = "Arc-Dark";
        package = pkgs.arc-theme;
      };

      iconTheme = {
        package = pkgs.arc-icon-theme;
        name = "Arc";
      };

      cursorTheme = {
        package = pkgs.vimix-cursors;
        name = "Vimix-cursors";
        size = cfg.theme.cursorSize;
      };

      gtk3.extraConfig = {
        Settings = lib.mkDefault ''
          gtk-application-prefer-dark-theme=1
        '';
      };

      gtk4.extraConfig = {
        Settings = lib.mkDefault ''
          gtk-application-prefer-dark-theme=1
        '';
      };
    };

    home.pointerCursor = {
      gtk.enable = lib.mkDefault true;
      name = "Vimix-cursors";
      package = pkgs.vimix-cursors;
      size = cfg.theme.cursorSize;
    };

    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "1";
      _JAVA_AWT_WM_NONEREPARENTING = "1";
      # SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
      DISABLE_QT5_COMPAT = "0";
      ANKI_WAYLAND = "1";
      DIRENV_LOG_FORMAT = "";
      WLR_DRM_NO_ATOMIC = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      # QT_QPA_PLATFORMTHEME = "qt5ct";
      # QT_STYLE_OVERRIDE = "kvantum";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_DBUS_REMOTE = "1";
      XDG_CURRENT_DESKTOP = "Hyprland";
      BEMENU_BACKEND = "wayland";
      ECORE_EVAS_ENGINE = "wayland_egl";
      ELM_ENGINE = "wayland_egl";
      WLR_BACKEND = "vulkan";
      WLR_RENDERER = "vulkan";
      WLR_NO_HARDWARE_CURSORS = "1";
      XDG_SESSION_TYPE = "wayland";
      # SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      GTK_THEME = "Dracula";
      WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland:xcb";
      GDK_BACKEND = "wayland";
      GDX_BACKEND = "wayland";
      # HYPRLAND_INSTANCE_SIGNATURE = "just_to_use_on_river";
    };
  };
}
