{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.home.wayland.hyprland;
in {
  options.local.home.wayland.hyprland = {
    enable = lib.mkEnableOption "Enable hyprland configuration";
    wallpaperPath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "wallpaper set location";
    };
    extraConfig = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "hyprland extra config string";
    };
    keyboard = {
      layout = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "hyprland keyboard layout string";
      };
      variant = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "hyprland keyboard variant string";
      };
      options = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "hyprland keyboard options string";
      };
    };
    animations.enable = lib.mkEnableOption "Enable hyprland animations";
    binds = {
      mainMod = lib.mkOption {
        type = lib.types.str; # TODO dont allow any string except the ones valid
        default = "SUPER";
        description = "hyprland mainMod";
      };
      config = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Bind list";
      };
      enableCycleWorkspaces = lib.mkEnableOption "Enable custom script that switches workspaces, returns to the previous workspace if the same bind is pressed again";
      enableExtraBinds = lib.mkEnableOption "Enable extra (opinated) binds like workspace switching, audio controls, kill window, fullscreen, etc";
    };
  };
  config = lib.mkIf cfg.enable {
    home.file.".wallpaper".source = cfg.wallpaperPath;

    home.packages = with pkgs; [
      swaybg
      grimblast
      hyprpicker
      hyprlock
      hyprland-qtutils
    ];

    wayland.windowManager.hyprland = {
      enable = lib.mkDefault true;

      extraConfig = cfg.extraConfig;
      settings = {
        exec = [
          (
            lib.optionals (! builtins.isNull cfg.wallpaperPath)
            "${lib.getExe pkgs.swaybg} -i ~/.wallpaper --mode fill"
          )
        ];

        input = {
          kb_layout = cfg.keyboard.layout;
          kb_variant = cfg.keyboard.variant;
          kb_options = cfg.keyboard.options;
          follow_mouse = 1;
          touchpad.natural_scroll = false;
          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
          repeat_delay = 300;
          repeat_rate = 50;
        };

        general = {
          "$mainMod" = cfg.binds.mainMod;
          layout = "dwindle";
          gaps_in = 0;
          gaps_out = 0;
          border_size = 2;
          "col.active_border" = "rgba(ccccffee) rgba(aacc99ee) 270deg";
          "col.inactive_border" = "rgba(595959aa)";
          no_border_on_floating = true;
        };

        misc = {
          disable_autoreload = true;
          disable_hyprland_logo = true;
          always_follow_on_dnd = true;
          layers_hog_keyboard_focus = true;
          animate_manual_resizes = false;
          enable_swallow = true;
          focus_on_activate = true;
          vrr = false;
        };

        dwindle = {
          force_split = 0;
          special_scale_factor = 1.0;
          split_width_multiplier = 1.0;
          use_active_for_splits = true;
          pseudotile = "yes";
          preserve_split = "yes";
        };

        master = {
          new_status = "master";
          special_scale_factor = 1;
        };

        animations.enabled = cfg.animations.enable;

        windowrulev2 = [
          # TODO have rules
          #firefox PiP window floating and sticky
          "float, title:^(Picture-in-Picture)$"
          "float, class:^(float|mpv|popup|imv|scrcpy|org.pulseaudio.pavucontrol|org.keepassxc.KeePassXC|org.qt-project.qml)$"
          # throw sharing indicators away
          "workspace special silent, title:^(Firefox — Sharing Indicator)$"
          "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"
          # steam in ws2
          "tile, title:^(Steam)$"
          "float, class:^(steam)$"
          "workspace 3 silent, class:^(steam)$"
          # idle inhibit while watching videos
          "idleinhibit focus, class:^(mpv|.*exe)$"
          "idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$"
          "idleinhibit fullscreen, class:^(firefox|chromium-browser)$"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        bind =
          cfg.binds.config
          ++ (
            let
              hyprctl = lib.getExe' pkgs.hyprland "hyprctl";
              switch-cycle = lib.getExe (pkgs.writeShellScriptBin "switch-cycle-workspaces" ''
                #!/usr/bin/env ${lib.getExe pkgs.bash}

                TARGET_WORKSPACE=$1
                PREV_WORKSPACE_FILE="/tmp/hyprland_prev_workspace"
                CURRENT_WORKSPACE=$(${hyprctl} monitors -j | jq -r '.[] | select(.focused==true).activeWorkspace.id')

                if [[ "$CURRENT_WORKSPACE" -eq "$TARGET_WORKSPACE" ]]; then
                  if [[ -f "$PREV_WORKSPACE_FILE" ]]; then
                    PREV_WORKSPACE=$(cat "$PREV_WORKSPACE_FILE")
                    ${hyprctl} dispatch workspace "$PREV_WORKSPACE"
                  else
                    echo "No previous workspace recorded. Staying on the current workspace."
                  fi
                else
                  echo "$CURRENT_WORKSPACE" > "$PREV_WORKSPACE_FILE"
                    ${hyprctl} dispatch workspace "$TARGET_WORKSPACE"
                fi
              '');
              switchWorkspace = num:
                if cfg.binds.enableCycleWorkspaces
                then "exec, ${switch-cycle} ${builtins.toString num}"
                else "workpace, ${num}";
            in [
              "$mainMod, 1, ${switchWorkspace 1}"
              "$mainMod, 2, ${switchWorkspace 2}"
              "$mainMod, 3, ${switchWorkspace 3}"
              "$mainMod, 4, ${switchWorkspace 4}"
              "$mainMod, 5, ${switchWorkspace 5}"
              "$mainMod, 6, ${switchWorkspace 6}"
              "$mainMod, 7, ${switchWorkspace 7}"
              "$mainMod, 8, ${switchWorkspace 8}"
              "$mainMod, 9, ${switchWorkspace 9}"
              "$mainMod, 0, ${switchWorkspace 0}"
            ]
          )
          ++ (
            lib.optionals cfg.binds.enableExtraBinds [
              # cycle workspaces
              "$mainMod, bracketleft, workspace, m-1"
              "$mainMod, bracketright, workspace, m+1"

              # Move active window to a workspace with mainMod + SHIFT + [0-9]
              "$mainMod SHIFT, 1, movetoworkspace, 1"
              "$mainMod SHIFT, 2, movetoworkspace, 2"
              "$mainMod SHIFT, 3, movetoworkspace, 3"
              "$mainMod SHIFT, 4, movetoworkspace, 4"
              "$mainMod SHIFT, 5, movetoworkspace, 5"
              "$mainMod SHIFT, 6, movetoworkspace, 6"
              "$mainMod SHIFT, 7, movetoworkspace, 7"
              "$mainMod SHIFT, 8, movetoworkspace, 8"
              "$mainMod SHIFT, 9, movetoworkspace, 9"
              "$mainMod SHIFT, 0, movetoworkspace, 10"

              "$mainMod, mouse_down, workspace, e+1"
              "$mainMod, mouse_up, workspace, e-1"

              # Move focus with mainMod + arrow keys
              "$mainMod, left, movefocus, l"
              "$mainMod, right, movefocus, r"
              "$mainMod, up, movefocus, u"
              "$mainMod, down, movefocus, d"

              # Misc
              "$mainMod, Q, killactive,"
              "$mainMod, F, fullscreen,"
              "$mainMod, G, togglegroup,"
              "$mainMod, N, changegroupactive, f"
              "$mainMod SHIFT, P, changegroupactive, b"
              "$mainMod, E, exit,"
              "$mainMod SHIFT, Space, togglefloating,"
              "$mainMod, P, pseudo," # dwindle
              "$mainMod, J, togglesplit," # dwindle
              "$mainMod SHIFT, F, exec, hyprctl dispatch dpms on" # fallsafe
            ]
            ++ (
              let
                playerctl = lib.getExe' config.services.playerctld.package "playerctl";
                playerctld = lib.getExe' config.services.playerctld.package "playerctld";
              in
                lib.optionals config.services.playerctld.enable [
                  # Media control
                  ", XF86AudioNext, exec, ${playerctl} next"
                  ", XF86AudioPrev, exec, ${playerctl} previous"
                  ", XF86AudioPlay, exec, ${playerctl} play-pause"
                  ", XF86AudioStop, exec, ${playerctl} stop"
                  "ALT, XF86AudioNext, exec, ${playerctld} shift"
                  "ALT, XF86AudioPrev, exec, ${playerctld} unshift"
                  "ALT, XF86AudioPlay, exec, systemctl --user restart playerctld"
                ]
            )
            # Screen lock
            ++ (
              let
                swaylock = lib.getExe config.programs.swaylock.package;
              in
                lib.optionals config.programs.swaylock.enable [
                  ", XF86Launch5, exec, ${swaylock} -S --grace 2"
                  ", XF86Launch4, exec, ${swaylock} -S --grace 2"
                  "$mainMod, backspace, exec, ${swaylock} -S --grace 2"
                ]
            )
            ++
            # Notification manager
            (
              let
                makoctl = lib.getExe' config.services.mako.package "makoctl";
              in
                lib.optionals config.services.mako.enable [
                  "$mainMod, W, exec,${makoctl} dismiss"
                  "$mainMod SHIFT, W, exec,${makoctl} restore"
                ]
            )
            # Launchers
            ++ (
              let
                wofi = lib.getExe config.programs.wofi.package;
                cliphist = lib.getExe config.services.cliphist.package;
              in
                lib.optionals config.programs.wofi.enable [
                  "$mainMod, D, exec, ${wofi} -S drun -x 10 -y 10 -W 25% -H 60%"
                  "$mainMod, X, exec, ${wofi} -S run"
                  "$mainMod, C, exec, selected=$(${cliphist} list | ${wofi} -S dmenu) && echo \"$selected\" | ${cliphist} decode | wl-copy"
                ]
            )
          );
      };
    };
  };
}
