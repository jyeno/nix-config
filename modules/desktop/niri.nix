{
  flake.modules.nixos.desktop-niri = {
    programs.niri = {
      enable = true;
      # package = self.packages.${pkgs.stdenv.hostPlatform.system}.jniri;
    };
  };

  flake.modules.homeManager.desktop-niri =
    {
      config,
      lib,
      ...
    }:
    {
      wayland.windowManager.niri = {
        enable = true;
        settings =
          let
            inherit (config.systemConstants.keyboard) xkb;
            inherit (config.systemConstants.keyboard) repeatDelay;
            inherit (config.systemConstants.keyboard) repeatRate;
          in
          {
            screenshot-path = "~/Pictures/screenshot_%Y-%m-%d %H-%M-%S.png";
            prefer-no-csd = { };

            spawn-sh-at-startup = [
              "systemctl --user start wl-session.target"
            ];

            cursor = {
              hide-when-typing = true;
              hide-after-inactive-ms = 1000;
            };

            input = {
              focus-follows-mouse = { };

              keyboard = {
                xkb = {
                  layout = "${xkb.layout}";
                  variant = "${xkb.variant}";
                  options = "${xkb.options}";
                };
                repeat-delay = repeatDelay;
                repeat-rate = repeatRate;
                track-layout = "global";
              };
              touchpad = {
                tap = { };
                dwt = { };
                accel-speed = 0.2;
                accel-profile = "flat";
                scroll-method = "two-finger";
              };
              mouse = {
                accel-speed = 1.0;
                accel-profile = "flat";
                scroll-method = "no-scroll";
              };
            };

            layout = {
              center-focused-column = "never";

              default-column-width = {
                proportion = 0.43;
              };
              focus-ring = {
                width = 4;
                active-color = "#7fc8ff";
                inactive-color = "#505050";
              };
            };
            hotkey-overlay = {
              skip-at-startup = { };
            };
            _children = [
              {
                window-rule._children = [
                  {
                    match._props = {
                      app-id = "r#'^org\.keepassxc\.KeePassXC$'#";
                    };
                  }
                  { open-floating = true; }
                  { block-out-from = "screen-capture"; }
                ];
              }
              {
                window-rule._children = [
                  {
                    match._props = {
                      app-id = "r#'firefox$'# title='^Picture-in-Picture$'";
                    };
                  }
                  { open-floating = true; }

                ];
              }
            ];

            binds =
              let
                mkActionProps = bind: action: props: {
                  "${bind}" = {
                    _props = props;
                    "${action}" = { };
                  };
                };
                mkAction = bind: action: mkActionProps bind action { };
                mkActionVal = bind: actionValue: { "${bind}" = actionValue; };
                # mkBind = bind: cmd: {
                #   "${bind}".spawn = cmd;
                # };
                # TODO add props
                # extraModsGen =
                #   extras:
                #   builtins.concatStringsSep " " (
                #     builtins.map (
                #       n:
                #       if n == "locked" then
                #         "allow-when-locked=${lib.boolToString extras.locked}"
                #       else if n == "description" then
                #         "hotkey-overlay-title=\"${extras.description}\""
                #       else
                #         ""
                #     ) (builtins.attrNames extras)
                #   );
                userBinds = builtins.listToAttrs (
                  map (
                    bind:
                    let
                      prefix = if bind.mod == "" then "" else "${bind.mod}+";
                    in
                    {
                      name = "${prefix}${builtins.concatStringsSep "+" bind.keys}";
                      value = {
                        spawn = [ "${bind.cmd}" ];
                      };
                    }
                  ) config.systemConstants.keyboard.binds
                );
                # userBinds = builtins.map (
                #   bind:
                #   let
                #     prefix = if bind.mod == "" then "" else "${bind.mod}+";
                #   in
                #   mkBind "${prefix}${builtins.concatStringsSep "+" bind.keys}" [ "${bind.cmd}" ]
                # ) config.systemConstants.keyboard.binds;
              in
              # `niri msg action do-something`.
              userBinds
              // (mkAction "Mod+Shift+Slash" "show-hotkey-overlay")
              // (mkActionProps "Mod+O" "toggle-overview" { repeat = false; })
              // (mkActionProps "Mod+Q" "close-window" { repeat = false; })
              // (mkAction "Mod+Left" "focus-column-left")
              // (mkAction "Mod+Down" "focus-window-down")
              // (mkAction "Mod+Up" "focus-window-up")
              // (mkAction "Mod+Right" "focus-column-right")
              // (mkAction "Mod+H" "focus-column-left")
              // (mkAction "Mod+J" "focus-window-down")
              // (mkAction "Mod+K" "focus-window-up")
              // (mkAction "Mod+L" "focus-column-right")
              // (mkAction "Mod+Shift+Slash" "show-hotkey-overlay")
              // (mkAction "Mod+Ctrl+Left" "move-column-left")
              // (mkAction "Mod+Ctrl+Down" "move-window-down")
              // (mkAction "Mod+Ctrl+Up" "move-window-up")
              // (mkAction "Mod+Ctrl+Right" "move-column-right")
              // (mkAction "Mod+Ctrl+H" "move-column-left")
              // (mkAction "Mod+Ctrl+J" "move-window-down")
              // (mkAction "Mod+Ctrl+K" "move-window-up")
              // (mkAction "Mod+Ctrl+L" "move-column-right")
              // (mkAction "Mod+Home" "focus-column-first")
              // (mkAction "Mod+End" "focus-column-last")
              // (mkAction "Mod+Ctrl+Home" "move-column-to-first")
              // (mkAction "Mod+Ctrl+End" "move-column-to-last")
              //

                (mkAction "Mod+Shift+Left" "focus-monitor-left")
              // (mkAction "Mod+Shift+Down" "focus-monitor-down")
              // (mkAction "Mod+Shift+Up" "focus-monitor-up")
              // (mkAction "Mod+Shift+Right" "focus-monitor-right")
              // (mkAction "Mod+Shift+H" "focus-monitor-left")
              // (mkAction "Mod+Shift+J" "focus-monitor-down")
              // (mkAction "Mod+Shift+K" "focus-monitor-up")
              // (mkAction "Mod+Shift+L" "focus-monitor-right")
              //

                (mkAction "Mod+Shift+Ctrl+Left" "move-column-to-monitor-left")
              // (mkAction "Mod+Shift+Ctrl+Down" "move-column-to-monitor-down")
              // (mkAction "Mod+Shift+Ctrl+Up" "move-column-to-monitor-up")
              // (mkAction "Mod+Shift+Ctrl+Right" "move-column-to-monitor-right")
              // (mkAction "Mod+Shift+Ctrl+H" "move-column-to-monitor-left")
              // (mkAction "Mod+Shift+Ctrl+J" "move-column-to-monitor-down")
              // (mkAction "Mod+Shift+Ctrl+K" "move-column-to-monitor-up")
              // (mkAction "Mod+Shift+Ctrl+L" "move-column-to-monitor-right")
              //

                (mkAction "Mod+Page_Down" "focus-workspace-down")
              // (mkAction "Mod+Page_Up" "focus-workspace-up")
              // (mkAction "Mod+U" "focus-workspace-down")
              // (mkAction "Mod+I" "focus-workspace-up")
              // (mkAction "Mod+Ctrl+Page_Down" "move-column-to-workspace-down")
              // (mkAction "Mod+Ctrl+Page_Up" "move-column-to-workspace-up")
              // (mkAction "Mod+Ctrl+U" "move-column-to-workspace-down")
              // (mkAction "Mod+Ctrl+I" "move-column-to-workspace-up")
              //

                (mkAction "Mod+Shift+Page_Down" "move-workspace-down")
              // (mkAction "Mod+Shift+Page_Up" "move-workspace-up")
              // (mkAction "Mod+Shift+U" "move-workspace-down")
              // (mkAction "Mod+Shift+I" "move-workspace-up")
              //

                (mkActionProps "Mod+WheelScrollDown" "focus-column-right" { cooldown-ms = 150; })
              // (mkActionProps "Mod+WheelScrollUp" "focus-column-left" { cooldown-ms = 150; })
              // (mkActionProps "Mod+Ctrl+WheelScrollDown" "move-column-to-workspace-down" { cooldown-ms = 150; })
              // (mkActionProps "Mod+Ctrl+WheelScrollUp" "move-column-to-workspace-up" { cooldown-ms = 150; })
              //

                (mkAction "Mod+WheelScrollRight" "focus-column-right")
              // (mkAction "Mod+WheelScrollLeft" "focus-column-left")
              // (mkAction "Mod+Ctrl+WheelScrollRight" "move-column-right")
              // (mkAction "Mod+Ctrl+WheelScrollLeft " "move-column-left")
              //

                (mkAction "Mod+Shift+WheelScrollDown" "focus-workspace-down")
              // (mkAction "Mod+Shift+WheelScrollUp" "focus-workspace-up")
              // (mkAction "Mod+Ctrl+Shift+WheelScrollDown" "move-column-right")
              // (mkAction "Mod+Ctrl+Shift+WheelScrollUp" "move-column-left")
              //

                (mkActionVal "Mod+1" { focus-workspace = 1; })
              // (mkActionVal "Mod+2" { focus-workspace = 2; })
              // (mkActionVal "Mod+3" { focus-workspace = 3; })
              // (mkActionVal "Mod+4" { focus-workspace = 4; })
              // (mkActionVal "Mod+5" { focus-workspace = 5; })
              // (mkActionVal "Mod+6" { focus-workspace = 6; })
              // (mkActionVal "Mod+7" { focus-workspace = 7; })
              // (mkActionVal "Mod+8" { focus-workspace = 8; })
              // (mkActionVal "Mod+9" { focus-workspace = 9; })
              // (mkActionVal "Mod+Ctrl+1" { move-column-to-workspace = 1; })
              // (mkActionVal "Mod+Ctrl+2" { move-column-to-workspace = 2; })
              // (mkActionVal "Mod+Ctrl+3" { move-column-to-workspace = 3; })
              // (mkActionVal "Mod+Ctrl+4" { move-column-to-workspace = 4; })
              // (mkActionVal "Mod+Ctrl+5" { move-column-to-workspace = 5; })
              // (mkActionVal "Mod+Ctrl+6" { move-column-to-workspace = 6; })
              // (mkActionVal "Mod+Ctrl+7" { move-column-to-workspace = 7; })
              // (mkActionVal "Mod+Ctrl+8" { move-column-to-workspace = 8; })
              // (mkActionVal "Mod+Ctrl+9" { move-column-to-workspace = 9; })
              //

                (mkAction "Mod+Tab" "focus-workspace-previous")
              //

                (mkAction "Mod+BracketLeft" "consume-or-expel-window-left")
              // (mkAction "Mod+BracketRight" "consume-or-expel-window-right")
              //

                (mkAction "Mod+Comma" "consume-window-into-column")
              // (mkAction "Mod+Period" "expel-window-from-column")
              //

                (mkAction "Mod+R" "switch-preset-column-width")
              // (mkAction "Mod+Shift+R" "switch-preset-window-height")
              // (mkAction "Mod+Ctrl+R" "reset-window-height")
              // (mkAction "Mod+F" "maximize-column")
              // (mkAction "Mod+Shift+F" "fullscreen-window")
              //

                (mkAction "Mod+Ctrl+F" "expand-column-to-available-width")
              //

                (mkAction "Mod+C" "center-column")
              //

                (mkAction "Mod+Ctrl+C" "center-visible-columns")
              //

                (mkActionVal "Mod+Minus" { set-column-width = "-10%"; })
              // (mkActionVal "Mod+Equal" { set-column-width = "+10%"; })
              //

                (mkActionVal "Mod+Shift+Minus" { set-window-height = "-10%"; })
              // (mkActionVal "Mod+Shift+Equal" { set-window-height = "+10%"; })
              //

                (mkAction "Mod+V" "toggle-window-floating")
              // (mkAction "Mod+Shift+V" "switch-focus-between-floating-and-tiling")
              //

                (mkAction "Mod+W" "toggle-column-tabbed-display")
              //

                (mkAction "Print" "screenshot")
              // (mkAction "Ctrl+Print" "screenshot-screen")
              // (mkAction "Alt+Print" "screenshot-window")
              //

                (mkActionProps "Mod+Escape" "toggle-keyboard-shortcuts-inhibit" { allow-inhibiting = false; })
              //

                (mkAction "Mod+Shift+E" "quit")
              // (mkAction "Ctrl+Alt+Delete" "quit")
              //

                (mkAction "Mod+Shift+P" "power-off-monitors");
          };
      };

    };
}
