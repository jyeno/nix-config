{
  flake.modules.nixos.desktop-wlr = {
    services.seatd.enable = true;
  };

  flake.modules.homeManager.desktop-wlr =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      home.packages = with pkgs; [
        wl-clipboard
        wayland-utils
      ];

      wayland.systemd.target = "wl-session.target";

      systemd.user.targets.wl-session = {
        Unit = {
          Description = "Generic wayland compositor session";
          Documentation = [ "man:systemd.special(7)" ];
          BindsTo = [ "graphical-session.target" ];
          Wants = [
            "graphical-session-pre.target"
          ];
        };
      };

      # TODO setup portal
      # xdg.portal = {
      #   enable = true;
      #   wlr.enable = true;
      #   xdgOpenUsePortal = true;
      #   config = {
      #     common.default = ["gtk"];
      #     hyprland.default = [
      #       "gtk"
      #       "hyprland"
      #     ];
      #   };
      #   extraPortals = [
      #     pkgs.xdg-desktop-portal-gtk
      #   ];
      # };
      home.sessionVariables = lib.mkDefault {
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
        cliphist.enable = lib.mkDefault true;
        wlsunset = {
          enable = true;
          systemdTarget = "wl-session.target";
          sunrise = "7:30";
          sunset = "19:30";
          gamma = 0.8;
        };
        swaync = {
          enable = true;
          settings = {
            positionX = "left";
            positionY = "top";
            cssPriority = "user";

            layer = "overlay";
            control-center-layer = "top";
            layer-shell = true;

            notification-window-width = 400;
            notification-icon-size = 64;
            notification-body-image-height = 200;
            notification-body-image-width = 200;

            timeout = 5;
            timeout-critical = 0;

            keyboard-shortcuts = true;
            image-visibility = "when-available";
            hide-on-clear = true;
            hide-on-action = true;
            text-empty = "No Notifications";
            script-fail-notify = true;
            widgets = [
              "dnd"
              "title"
              "notifications"
            ];
            widget-config = {
              notifications = {
                vexpand = false;
              };
              dnd = {
                text = "Do Not Disturb";
              };
              title = {
                text = "Notifications";
                clear-all-button = true;
                button-text = " 󰆴 ";
              };
            };
          };
        };
        swww.enable = true; # TODO stylix and awww
        # wpaperd.enable = true;
        # hyprpaper.enable = lib.mkDefault true;
      };
      systemd.user.services.awww = {
        # TODO change binary to awww
        Unit = {
          Description = "Awww wallpaper daemon";
          After = [ "wl-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.swww}/bin/swww-daemon";
          Restart = "always";
        };
        Install.WantedBy = [ "wl-session.target" ];
      };

      programs = {
        imv.enable = lib.mkDefault true;
        fuzzel.enable = lib.mkDefault true;
      };
    };
}
