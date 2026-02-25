{
  flake.modules.nixos.desktop-hyprland = {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
  };

  flake.modules.homeManager.desktop-hyprland =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      mainMod = "SUPER";
      inherit (config.systemConstants.keyboard) xkb;
      userBinds = builtins.map (
        bind:
        let
          keysLength = builtins.length bind.keys;
          keyReversed = lib.reverseList bind.keys;
          prefix = if bind.mod == "" then "" else "${bind.mod}";
          extraKeys =
            if keysLength > 1 then
              " ${builtins.concatStringsSep " " (lib.reverseList (builtins.tail keyReversed))}"
            else
              "";
          key = if bind.keys == [ ] then "" else "${builtins.head keyReversed}";
        in
        "${prefix}${extraKeys}, ${key}, exec, ${bind.cmd}"
      ) config.systemConstants.keyboard.binds;
    in
    {
      home.packages = with pkgs; [
        swaybg
        grimblast
        hyprpicker
        hyprland-qtutils
        wl-clipboard
        wayland-utils
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        systemd = {
          enable = true;
          extraCommands = [
            "systemctl --user stop wl-session.target"
            "systemctl --user start wl-session.target"
          ];
        };
        package = null; # evade portal errors when nixos and home module are being used, TODO
        portalPackage = null;
        plugins = with pkgs.hyprlandPlugins; [
          #TODO add hyprscrolling
          hyprexpo
        ];
        extraConfig = ''
          monitor = DP-1, 3440x1440@165, 0x0, 1, bitdepth, 10, cm, hdr, sdrbrightness, 1.2, sdrsaturation, 0.98, vrr, 1
        '';
        settings = {
          input = {
            kb_layout = xkb.layout;
            kb_variant = xkb.variant;
            kb_options = xkb.options;
            repeat_delay = config.systemConstants.keyboard.repeatDelay;
            repeat_rate = config.systemConstants.keyboard.repeatRate;
            follow_mouse = 1;
            touchpad.natural_scroll = false;
            sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
          };

          general = {
            "$mainMod" = mainMod;
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

          animations.enabled = false;

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
            "${mainMod}, mouse:272, movewindow"
            "${mainMod}, mouse:273, resizewindow"
          ];

          bind =
            userBinds
            ++ (
              let
                hyprctl = lib.getExe' pkgs.hyprland "hyprctl";
                switch-cycle = lib.getExe (
                  pkgs.writeShellScriptBin "switch-cycle-workspaces" ''
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
                  ''
                );
              in
              [
                "${mainMod}, 1, exec, ${switch-cycle} 1"
                "${mainMod}, 2, exec, ${switch-cycle} 2"
                "${mainMod}, 3, exec, ${switch-cycle} 3"
                "${mainMod}, 4, exec, ${switch-cycle} 4"
                "${mainMod}, 5, exec, ${switch-cycle} 5"
                "${mainMod}, 6, exec, ${switch-cycle} 6"
                "${mainMod}, 7, exec, ${switch-cycle} 7"
                "${mainMod}, 8, exec, ${switch-cycle} 8"
                "${mainMod}, 9, exec, ${switch-cycle} 9"
                "${mainMod}, 0, exec, ${switch-cycle} 0"

                # cycle workspaces
                "${mainMod}, bracketleft, workspace, m-1"
                "${mainMod}, bracketright, workspace, m+1"

                # Move active window to a workspace with mainMod + SHIFT + [0-9]
                "${mainMod} SHIFT, 1, movetoworkspace, 1"
                "${mainMod} SHIFT, 2, movetoworkspace, 2"
                "${mainMod} SHIFT, 3, movetoworkspace, 3"
                "${mainMod} SHIFT, 4, movetoworkspace, 4"
                "${mainMod} SHIFT, 5, movetoworkspace, 5"
                "${mainMod} SHIFT, 6, movetoworkspace, 6"
                "${mainMod} SHIFT, 7, movetoworkspace, 7"
                "${mainMod} SHIFT, 8, movetoworkspace, 8"
                "${mainMod} SHIFT, 9, movetoworkspace, 9"
                "${mainMod} SHIFT, 0, movetoworkspace, 10"

                "${mainMod}, mouse_down, workspace, e+1"
                "${mainMod}, mouse_up, workspace, e-1"

                # Move focus with mainMod + arrow keys
                "${mainMod}, left, movefocus, l"
                "${mainMod}, right, movefocus, r"
                "${mainMod}, up, movefocus, u"
                "${mainMod}, down, movefocus, d"

                # Misc
                "${mainMod}, Q, killactive,"
                "${mainMod}, F, fullscreen,"
                "${mainMod}, A, hyprexpo:expo, toggle"
                "${mainMod}, G, togglegroup,"
                "${mainMod}, N, changegroupactive, f"
                "${mainMod} SHIFT, P, changegroupactive, b"
                "${mainMod}, E, exit,"
                "${mainMod} SHIFT, Space, togglefloating,"
                "${mainMod}, P, pseudo," # dwindle
                "${mainMod}, J, togglesplit," # dwindle
                "${mainMod} SHIFT, F, exec, hyprctl dispatch dpms on" # fallsafe
              ]
            );
        };
      };
    };
}
