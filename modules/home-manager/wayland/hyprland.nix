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
  };
  config = lib.mkIf cfg.enable {
    # TODO add more options
    home.file.".wallpaper.png".source = ./wallpaper.png;

    home.packages = with pkgs; [
      swaybg
      grimblast
      hyprpicker
      hyprlock
      hyprland-qtutils
    ];

    wayland.windowManager.hyprland = {
      enable = true;

      # TODO add if sunyata
      # extraConfig = ''
      #   monitor = DP-1, 3440x1440@165, 0x0, 1, bitdepth, 10, cm, hdr, sdrbrightness, 1.2, sdrsaturation, 0.98, vrr, 1
      # '';
      settings = {
        exec = ["${pkgs.swaybg}/bin/swaybg -i ~/.wallpaper.png --mode fill"];

        input = {
          kb_layout = "us,us";
          kb_variant = ",workman-intl";
          kb_options = "ctrl:nocaps,grp:win_space_toggle";
          follow_mouse = 0;
          touchpad = {
            natural_scroll = false;
          };
          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
          repeat_delay = 300;
          repeat_rate = 50;
        };

        general = {
          "$mainMod" = "SUPER";
          layout = "dwindle";
          gaps_in = 0;
          gaps_out = 0;
          border_size = 2;
          "col.active_border" = "rgba(ccccffee) rgba(aacc99ee) 270deg";
          "col.inactive_border" = "rgba(595959aa)";
          # border_part_of_window = false;
          no_border_on_floating = false;
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
          # no_gaps_when_only = true;
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
          # no_gaps_when_only = false;
        };

        # decoration = {
        #   rounding = 0;

        #   # blur.enable = false;

        #   drop_shadow = true;

        #   shadow_ignore_window = true;
        #   shadow_offset = "0 2";
        #   shadow_range = 20;
        #   shadow_render_power = 3;
        #   "col.shadow" = "rgba(00000055)";
        # };

        animations.enabled = false;

        windowrulev2 = [
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
          # fix xwayland apps
          # "rounding 0, xwayland:1, floating:1"
          # "center, class:^(.*jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|win201|splash)$"
          # "size 640 400, class:^(.*jetbrains.*)$, title:^(splash)$"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        bind = let
          grimblast = lib.getExe pkgs.grimblast;
          steam = "/run/current-system/sw/bin/steam";
          telegram = lib.getExe pkgs.materialgram;
          light = lib.getExe pkgs.light;
          foot = lib.getExe' pkgs.foot "footclient";
          ghostty = lib.getExe pkgs.ghostty;
          tesseract = lib.getExe pkgs.tesseract;
          pactl = lib.getExe' pkgs.pulseaudio "pactl";
          notify-send = lib.getExe' pkgs.libnotify "notify-send";
          defaultApp = type: "${lib.getExe pkgs.handlr-regex} launch ${type}";
          remote = lib.getExe (pkgs.writeShellScriptBin "remote" ''
            socket="$(basename "$(find ~/.ssh -name 'master-*' | head -1 | cut -d ':' -f1)")"
            host="''${socket#master-}"
            ssh "$host" "$@"
          '');
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
        in
          [
            # Program bindings
            "SUPER, Return, exec, ${foot} sh -c 'tmux at -t 0 || tmux'"
            "SUPER ALT, Return, exec, ${ghostty}"
            # "SUPER, Return, exec, ${defaultApp "x-scheme-handler/terminal"}"
            "SUPER, e, exec, ${defaultApp "text/plain"}"
            "SUPER, b, exec, ${defaultApp "x-scheme-handler/https"}"
            "SUPER, s, exec, ${steam}"
            "SUPER, t, exec, ${telegram}"
            # "SUPERALT, Return, exec, ${remote} ${defaultApp "x-scheme-handler/terminal"}"
            "SUPER ALT, e, exec, ${remote} ${defaultApp "text/plain"}"
            "SUPER ALT, b, exec, ${remote} ${defaultApp "x-scheme-handler/https"}"
            # Brightness control (only works if the system has lightd)
            ", XF86MonBrightnessUp, exec, ${light} -A 10"
            ", XF86MonBrightnessDown, exec, ${light} -U 10"
            # Volume
            ", XF86AudioRaiseVolume, exec, ${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
            ", XF86AudioLowerVolume, exec, ${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
            ", XF86AudioMute, exec, ${pactl} set-sink-mute @DEFAULT_SINK@ toggle"
            "SHIFT, XF86AudioMute, exec, ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
            ", XF86AudioMicMute, exec, ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
            # Screenshotting
            ", Print, exec, ${grimblast} --notify copy output"
            "SUPER, Print, exec, ${grimblast} --notify copy area"
            # To OCR
            "ALT, Print, exec, ${grimblast} save area - | ${tesseract} - - | wl-copy && ${notify-send} -t 3000 'OCR result copied to buffer'"

            # cycle workspaces
            "SUPER, bracketleft, workspace, m-1"
            "SUPER, bracketright, workspace, m+1"

            # Switch workspaces with mainMod + [0-9]
            "SUPER, 1, exec, ${switch-cycle} 1"
            "SUPER, 2, exec, ${switch-cycle} 2"
            "SUPER, 3, exec, ${switch-cycle} 3"
            "SUPER, 4, exec, ${switch-cycle} 4"
            "SUPER, 5, exec, ${switch-cycle} 5"
            "SUPER, 6, exec, ${switch-cycle} 6"
            "SUPER, 7, exec, ${switch-cycle} 7"
            "SUPER, 8, exec, ${switch-cycle} 8"
            "SUPER, 9, exec, ${switch-cycle} 9"
            "SUPER, 0, exec, ${switch-cycle} 10"
            # Move active window to a workspace with mainMod + SHIFT + [0-9]
            "SUPER SHIFT, 1, movetoworkspace, 1"
            "SUPER SHIFT, 2, movetoworkspace, 2"
            "SUPER SHIFT, 3, movetoworkspace, 3"
            "SUPER SHIFT, 4, movetoworkspace, 4"
            "SUPER SHIFT, 5, movetoworkspace, 5"
            "SUPER SHIFT, 6, movetoworkspace, 6"
            "SUPER SHIFT, 7, movetoworkspace, 7"
            "SUPER SHIFT, 8, movetoworkspace, 8"
            "SUPER SHIFT, 9, movetoworkspace, 9"
            "SUPER SHIFT, 0, movetoworkspace, 10"

            # Move/resize windows with mainMod + LMB/RMB and dragging
            # "SUPER, mouse:272, movewindow"
            # "SUPER, mouse:273, resizewindow"
            # Scroll through existing workspaces with mainMod + scroll
            "SUPER, mouse_down, workspace, e+1"
            "SUPER, mouse_up, workspace, e-1"

            # Move focus with mainMod + arrow keys
            "SUPER, left, movefocus, l"
            "SUPER, right, movefocus, r"
            "SUPER, up, movefocus, u"
            "SUPER, down, movefocus, d"

            # Misc
            "SUPER, Q, killactive,"
            "SUPER, F, fullscreen,"
            "SUPER, G, togglegroup,"
            "SUPER, N, changegroupactive, f"
            "SUPER SHIFT, P, changegroupactive, b"
            "SUPER, E, exit,"
            "SUPER SHIFT, Space, togglefloating,"
            "SUPER, P, pseudo," # dwindle
            "SUPER, J, togglesplit," # dwindle
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
                "SUPER, backspace, exec, ${swaylock} -S --grace 2"
              ]
          )
          ++
          # Notification manager
          (
            let
              makoctl = lib.getExe' config.services.mako.package "makoctl";
            in
              lib.optionals config.services.mako.enable [
                "SUPER, w, exec,${makoctl} dismiss"
                "SUPERSHIFT, w, exec,${makoctl} restore"
              ]
          )
          # Launchers
          ++ (
            let
              wofi = lib.getExe config.programs.wofi.package;
              cliphist = lib.getExe config.services.cliphist.package;
            in
              lib.optionals config.programs.wofi.enable [
                "SUPER, d, exec, ${wofi} -S drun -x 10 -y 10 -W 25% -H 60%"
                # "SUPER, s, exec, specialisation $(specialisation | ${wofi} -S dmenu)"
                "SUPER, x, exec, ${wofi} -S run"
                "Super, c, exec, selected=$(${cliphist} list | ${wofi} -S dmenu) && echo \"$selected\" | ${cliphist} decode | wl-copy"

                "SUPER ALT, x, exec, ${remote} ${wofi} -S drun -x 10 -y 10 -W 25% -H 60%"
                "SUPER ALT, d, exec, ${remote} ${wofi} -S run"
              ]
          );
        # password manager
        # ++ (
        #   let
        #     pass-wofi = lib.getExe (pkgs.pass-wofi.override {pass = config.programs.password-store.package;});
        #   in
        #     lib.optionals config.programs.password-store.enable [
        #       ",Scroll_Lock,exec,${pass-wofi}" # fn+k
        #       ",XF86Calculator,exec,${pass-wofi}" # fn+f12
        #       "SUPER,semicolon,exec,${pass-wofi}"
        #       "SHIFT,Scroll_Lock,exec,${pass-wofi} fill" # fn+k
        #       "SHIFT,XF86Calculator,exec,${pass-wofi} fill" # fn+f12
        #       "SHIFTSUPER,semicolon,exec,${pass-wofi} fill"
        #     ]
        # );
      };
    };
  };
}
