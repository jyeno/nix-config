{
  flake.modules.homeManager.desktop-wlr = {
    pkgs,
    lib,
    config,
    ...
  }: {
    home.packages = with pkgs; [
      wl-clipboard
      wayland-utils
    ];

    # TODO setup portal
    # programs.light.enable = true; # TODO remove
    # services.seatd.enable = true;

    # xdg.portal = {
    #   enable = true;
    #   wlr.enable = true;
    #   xdgOpenUsePortal = true;
    #   extraPortals = [
    #     pkgs.xdg-desktop-portal-gtk
    #   ];
    # };
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "1";
      _JAVA_AWT_WM_NONEREPARENTING = "1";
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
      BEMENU_BACKEND = "wayland";
      ECORE_EVAS_ENGINE = "wayland_egl";
      ELM_ENGINE = "wayland_egl";
      WLR_BACKEND = "vulkan";
      WLR_RENDERER = "vulkan";
      WLR_NO_HARDWARE_CURSORS = "1";
      XDG_SESSION_TYPE = "wayland";
      # SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland:xcb";
      GDK_BACKEND = "wayland";
      GDX_BACKEND = "wayland";
    };
    services = {
      cliphist.enable = true;
      # hyprsunset = {
      #   enable = true;
      #   systemdTarget = "hyprland-session.target";
      #   settings = {
      #     max-gamma = 150;
      #     profile = [
      #       {
      #         time = "7:30";
      #         identity = true;
      #       }
      #       {
      #         time = "19:30";
      #         temperature = 5000;
      #         gamma = 0.8;
      #       }
      #     ];
      #   };
      # };
      fnott = {
        # TODO maybe move or inhibit when plasma
        enable = true;
        settings.main = {
          notification-margin = 5;
          default-timeout = 5;
          anchor = "bottom-left";
          min-width = 360;
          max-width = 360;
        };
      };
    };
    programs = {
      imv.enable = true;
      fuzzel.enable = true;
    };
  };
}
