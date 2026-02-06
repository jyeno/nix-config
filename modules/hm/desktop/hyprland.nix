{
  config,
  lib,
  pkgs,
  ...
}: let
  desktop = config.local.home.desktop;
  cfg = desktop.hyprland;
  userBinds =
    builtins.map (
      bind: let
        keysLength = builtins.length bind.keys;
        prefix =
          if bind.mod == ""
          then ""
          else "${bind.mod}";
        extraKeys =
          if keysLength > 1
          then " ${builtins.concatStringsSep " " (builtins.take (keysLength - 1) bind.keys)}"
          else "";
        key =
          if bind.keys == []
          then ""
          else "${builtins.elemAt bind.keys (keysLength - 1)}";
      in "${prefix}${extraKeys}, ${key}, exec, ${bind.cmd}"
    )
    desktop.keyboard.binds;
in {
  options.local.home.desktop.hyprland = {
    enable = lib.mkEnableOption "Enable hyprland configuration";
    extraConfig = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "hyprland extra config string";
    };
    animations.enable = lib.mkEnableOption "Enable hyprland animations";
    binds = {
      mainMod = lib.mkOption {
        type = lib.types.str; # TODO dont allow any string except the ones valid
        default = "SUPER";
        description = "hyprland mainMod";
      };
      enableCycleWorkspaces = lib.mkEnableOption "Enable custom script that switches workspaces, returns to the previous workspace if the same bind is pressed again";
      enableExtraBinds = lib.mkEnableOption "Enable extra (opinated) binds like workspace switching, audio controls, kill window, fullscreen, etc";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      swaybg
      grimblast
      hyprpicker
      hyprland-qtutils
      wl-clipboard
      wayland-utils
    ];

    wayland.windowManager.hyprland = {
      enable = lib.mkDefault true;
      systemd.enable = true;
      package = null; # evade portal errors when nixos and home module are being used, TODO
      portalPackage = null;
      plugins = with pkgs.hyprlandPlugins; [
        #TODO add hyprscrolling
        hyprexpo
      ];
      extraConfig = cfg.extraConfig;
      settings = {
        input = {
          kb_layout = desktop.keyboard.xkb.layout;
          kb_variant = desktop.keyboard.xkb.variant;
          kb_options = desktop.keyboard.xkb.options;
          repeat_delay = desktop.keyboard.repeatDelay;
          repeat_rate = desktop.keyboard.repeatRate;
          follow_mouse = lib.mkDefault 1;
          touchpad.natural_scroll = lib.mkDefault false;
          sensitivity = lib.mkDefault 0; # -1.0 - 1.0, 0 means no modification.
        };

        general = {
          "$mainMod" = cfg.binds.mainMod;
          layout = "dwindle";
          gaps_in = 0;
          gaps_out = 0;
          border_size = 2;
        };

        misc = {
          disable_autoreload = true;
          disable_hyprland_logo = true;
          always_follow_on_dnd = true;
          layers_hog_keyboard_focus = true;
          animate_manual_resizes = false;
          enable_swallow = true;
          focus_on_activate = true;
          vrr = true;
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

        windowrule = [
          # TODO have rules
          "match:class ^(discord|WebCord|vesktop)$, workspace 3"

          "match:class ^(rofi)$, pin on"

          "match:class ^(float|waypaper|zenity|mpv|popup|imv|scrcpy|org.pulseaudio.pavucontrol|org.keepassxc.KeePassXC|org.qt-project.qml)$, float on"

          # steam in ws2
          "match:title ^(Steam)$, tile on"
          "match:class ^(steam), float on$"
          "match:class ^(steam)$, workspace 2 silent"

          "match:title ^(Volume Control)$, size 700 450"
          "match:title ^(Volume Control)$, move 40 55%"

          #firefox PiP window floating and sticky
          "match:title ^(Picture-in-Picture)$, pin on"
          "match:title ^(Picture-in-Picture)$, float on"

          # throw sharing indicators away
          "match:title ^(Firefox — Sharing Indicator)$, workspace special silent"
          "match:title ^(.*is sharing (your screen|a window)\.)$, workspace special silent"

          # idle inhibit while watching videos
          "match:class ^(mpv|.*exe)$, idle_inhibit focus"
          "match:title ^(.*YouTube.*)$, idle_inhibit focus"
          "match:class ^(firefox|chromium-browser)$, idle_inhibit fullscreen"

          "match:class ^(xdg-desktop-portal-gtk)$, dim_around on"
        ];

        bindm = [
          "${cfg.binds.mainMod}, mouse:272, movewindow"
          "${cfg.binds.mainMod}, mouse:273, resizewindow"
        ];

        bind =
          userBinds
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
              "${cfg.binds.mainMod}, 1, ${switchWorkspace 1}"
              "${cfg.binds.mainMod}, 2, ${switchWorkspace 2}"
              "${cfg.binds.mainMod}, 3, ${switchWorkspace 3}"
              "${cfg.binds.mainMod}, 4, ${switchWorkspace 4}"
              "${cfg.binds.mainMod}, 5, ${switchWorkspace 5}"
              "${cfg.binds.mainMod}, 6, ${switchWorkspace 6}"
              "${cfg.binds.mainMod}, 7, ${switchWorkspace 7}"
              "${cfg.binds.mainMod}, 8, ${switchWorkspace 8}"
              "${cfg.binds.mainMod}, 9, ${switchWorkspace 9}"
              "${cfg.binds.mainMod}, 0, ${switchWorkspace 0}"
            ]
          )
          ++ (
            lib.optionals cfg.binds.enableExtraBinds [
              # cycle workspaces
              "${cfg.binds.mainMod}, bracketleft, workspace, m-1"
              "${cfg.binds.mainMod}, bracketright, workspace, m+1"

              # Move active window to a workspace with mainMod + SHIFT + [0-9]
              "${cfg.binds.mainMod} SHIFT, 1, movetoworkspace, 1"
              "${cfg.binds.mainMod} SHIFT, 2, movetoworkspace, 2"
              "${cfg.binds.mainMod} SHIFT, 3, movetoworkspace, 3"
              "${cfg.binds.mainMod} SHIFT, 4, movetoworkspace, 4"
              "${cfg.binds.mainMod} SHIFT, 5, movetoworkspace, 5"
              "${cfg.binds.mainMod} SHIFT, 6, movetoworkspace, 6"
              "${cfg.binds.mainMod} SHIFT, 7, movetoworkspace, 7"
              "${cfg.binds.mainMod} SHIFT, 8, movetoworkspace, 8"
              "${cfg.binds.mainMod} SHIFT, 9, movetoworkspace, 9"
              "${cfg.binds.mainMod} SHIFT, 0, movetoworkspace, 10"

              "${cfg.binds.mainMod}, mouse_down, workspace, e+1"
              "${cfg.binds.mainMod}, mouse_up, workspace, e-1"

              # Move focus with mainMod + arrow keys
              "${cfg.binds.mainMod}, left, movefocus, l"
              "${cfg.binds.mainMod}, right, movefocus, r"
              "${cfg.binds.mainMod}, up, movefocus, u"
              "${cfg.binds.mainMod}, down, movefocus, d"

              # Misc
              "${cfg.binds.mainMod}, Q, killactive,"
              "${cfg.binds.mainMod}, F, fullscreen,"
              "${cfg.binds.mainMod}, A, hyprexpo:expo, toggle"
              "${cfg.binds.mainMod}, G, togglegroup,"
              "${cfg.binds.mainMod}, N, changegroupactive, f"
              "${cfg.binds.mainMod} SHIFT, P, changegroupactive, b"
              "${cfg.binds.mainMod}, E, exit,"
              "${cfg.binds.mainMod} SHIFT, Space, togglefloating,"
              "${cfg.binds.mainMod}, P, pseudo," # dwindle
              "${cfg.binds.mainMod}, J, togglesplit," # dwindle
              "${cfg.binds.mainMod} SHIFT, F, exec, hyprctl dispatch dpms on" # fallsafe
            ]
          );
      };
    };
  };
}
