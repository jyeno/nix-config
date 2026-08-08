{ self, inputs, ... }: {
  flake.modules.nixos.desktop-niri = { lib, pkgs, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.jniri;
    };
  };

  perSystem =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      packages.jniri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings =
          let
            inherit (config.systemConstants.keyboard) xkb;
            inherit (config.systemConstants.keyboard) repeatDelay;
            inherit (config.systemConstants.keyboard) repeatRate;
            userBinds = builtins.map (
              bind:
              let
                # TODO make it more foolproof, check types
                prefix = if bind.mod == "" then "" else "${bind.mod}+";
                extraModsGen =
                  extras:
                  builtins.concatStringsSep " " (
                    builtins.map (
                      n:
                      if n == "locked" then
                        "allow-when-locked=${lib.boolToString extras.locked}"
                      else if n == "description" then
                        "hotkey-overlay-title=\"${extras.description}\""
                      else
                        ""
                    ) (builtins.attrNames extras)
                  );
              in
              "${prefix}${builtins.concatStringsSep "+" bind.keys} ${extraModsGen bind.extras} { spawn-sh \"${bind.cmd}\"; }"
            ) config.systemConstants.keyboard.binds;
          in
          {
            xscreenshot-path = "~/Pictures/screenshot_%Y-%m-%d %H-%M-%S.png";
            prefer-no-csd = null;

            spawn-sh-at-startup = [
              "systemctl --user stop wl-session.target"
              "systemctl --user start wl-session.target"
            ];

            cursor = {
              hide-when-typing = true;
              hide-after-inactive-ms = 1000;
            };

            input = {
              focus-follows-mouse = null;

              keyboard = {
                xkb = {
                  layout = "${xkb.layout}";
                  variant = "${xkb.variant}";
                  options = "${xkb.options}";
                };
                repeat-delay = "${builtins.toString repeatDelay}";
                repeat-rate = "${builtins.toString repeatRate}";
                track-layout = "global";
              };
              touchpad = {
                tap = null;
                dwt = null;
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
              # tab-indicator {
              #   on
              #   hide-when-single-tab
              #   place-within-column
              #   gap 5
              #   width 4
              #   length total-proportion=1.0
              #   position "right"
              #   gaps-between-tabs 2
              #   corner-radius 8
              #   active-color "red"
              #   inactive-color "gray"
              #   urgent-color "blue"
              # }
              # insert-hint {
              #   on
              #   color "#ffc87f80"
              # }
              # struts {
              #   // left 64
              #   // right 64
              #   // top 64
              #   // bottom 64
              # }
            };
            hotkey-overlay = {
              skip-at-startup = null;
            };
            _children = [
              {
                window-rule._children = [
                  {
                    match._props = {
                      app-id = "r#'firefox$'# title='^Picture-in-Picture$'";
                      open-floating = true;
                    };
                  }

                  {
                    match._props = {
                      app-id = "r#'^org\.keepassxc\.KeePassXC$'#";
                      open-floating = true;
                      block-out-from = "screen-capture";
                    };
                  }
                ];
              }
            ];

            binds =
              let
                mkBindProps = bind: action: props: {
                  "$bind" = {
                    _props = props;
                    "$action" = null;
                  };
                };
                mkBind = bind: action: { "$bind"."$action" = null; };
                mkBindVal = bind: actionValue: { "$bind" = actionValue; };
              in
              # `niri msg action do-something`.

              # ${builtins.concatStringsSep "\n\t" userBinds};
              (mkBind "Mod+Shift+Slash" "show-hotkey-overlay")
              // (mkBindProps "Mod+O" "toggle-overview" { repeat = false; })
              // (mkBindProps "Mod+Q" "close-window" { repeat = false; })
              // (mkBind "Mod+Left" "focus-column-left")
              // (mkBind "Mod+Down" "focus-window-down")
              // (mkBind "Mod+Up" "focus-window-up")
              // (mkBind "Mod+Right" "focus-column-right")
              // (mkBind "Mod+H" "focus-column-left")
              // (mkBind "Mod+J" "focus-window-down")
              // (mkBind "Mod+K" "focus-window-up")
              // (mkBind "Mod+L" "focus-column-right")
              // (mkBind "Mod+Shift+Slash" "show-hotkey-overlay")
              // (mkBind "Mod+Ctrl+Left" "move-column-left")
              // (mkBind "Mod+Ctrl+Down" "move-window-down")
              // (mkBind "Mod+Ctrl+Up" "move-window-up")
              // (mkBind "Mod+Ctrl+Right" "move-column-right")
              // (mkBind "Mod+Ctrl+H" "move-column-left")
              // (mkBind "Mod+Ctrl+J" "move-window-down")
              // (mkBind "Mod+Ctrl+K" "move-window-up")
              // (mkBind "Mod+Ctrl+L" "move-column-right")
              // (mkBind "Mod+Home" "focus-column-first")
              // (mkBind "Mod+End" "focus-column-last")
              // (mkBind "Mod+Ctrl+Home" "move-column-to-first")
              // (mkBind "Mod+Ctrl+End" "move-column-to-last")
              //

                (mkBind "Mod+Shift+Left" "focus-monitor-left")
              // (mkBind "Mod+Shift+Down" "focus-monitor-down")
              // (mkBind "Mod+Shift+Up" "focus-monitor-up")
              // (mkBind "Mod+Shift+Right" "focus-monitor-right")
              // (mkBind "Mod+Shift+H" "focus-monitor-left")
              // (mkBind "Mod+Shift+J" "focus-monitor-down")
              // (mkBind "Mod+Shift+K" "focus-monitor-up")
              // (mkBind "Mod+Shift+L" "focus-monitor-right")
              //

                (mkBind "Mod+Shift+Ctrl+Left" "move-column-to-monitor-left")
              // (mkBind "Mod+Shift+Ctrl+Down" "move-column-to-monitor-down")
              // (mkBind "Mod+Shift+Ctrl+Up" "move-column-to-monitor-up")
              // (mkBind "Mod+Shift+Ctrl+Right" "move-column-to-monitor-right")
              // (mkBind "Mod+Shift+Ctrl+H" "move-column-to-monitor-left")
              // (mkBind "Mod+Shift+Ctrl+J" "move-column-to-monitor-down")
              // (mkBind "Mod+Shift+Ctrl+K" "move-column-to-monitor-up")
              // (mkBind "Mod+Shift+Ctrl+L" "move-column-to-monitor-right")
              //

                (mkBind "Mod+Page_Down" "focus-workspace-down")
              // (mkBind "Mod+Page_Up" "focus-workspace-up")
              // (mkBind "Mod+U" "focus-workspace-down")
              // (mkBind "Mod+I" "focus-workspace-up")
              // (mkBind "Mod+Ctrl+Page_Down" "move-column-to-workspace-down")
              // (mkBind "Mod+Ctrl+Page_Up" "move-column-to-workspace-up")
              // (mkBind "Mod+Ctrl+U" "move-column-to-workspace-down")
              // (mkBind "Mod+Ctrl+I" "move-column-to-workspace-up")
              //

                (mkBind "Mod+Shift+Page_Down" "move-workspace-down")
              // (mkBind "Mod+Shift+Page_Up" "move-workspace-up")
              // (mkBind "Mod+Shift+U" "move-workspace-down")
              // (mkBind "Mod+Shift+I" "move-workspace-up")
              //

                (mkBind "Mod+WheelScrollDown      cooldown-ms=150" "focus-column-right")
              // (mkBind "Mod+WheelScrollUp        cooldown-ms=150" "focus-column-left")
              // (mkBind "Mod+Ctrl+WheelScrollDown cooldown-ms=150" "move-column-to-workspace-down")
              // (mkBind "Mod+Ctrl+WheelScrollUp   cooldown-ms=150" "move-column-to-workspace-up")
              //

                (mkBind "Mod+WheelScrollRight" "focus-column-right")
              // (mkBind "Mod+WheelScrollLeft" "focus-column-left")
              // (mkBind "Mod+Ctrl+WheelScrollRight" "move-column-right")
              // (mkBind "Mod+Ctrl+WheelScrollLeft " "move-column-left")
              //

                (mkBind "Mod+Shift+WheelScrollDown" "focus-workspace-down")
              // (mkBind "Mod+Shift+WheelScrollUp" "focus-workspace-up")
              // (mkBind "Mod+Ctrl+Shift+WheelScrollDown" "move-column-right")
              // (mkBind "Mod+Ctrl+Shift+WheelScrollUp" "move-column-left")
              //

                (mkBindVal "Mod+1" { focus-workspace = 1; })
              // (mkBindVal "Mod+2" { focus-workspace = 2; })
              // (mkBindVal "Mod+3" { focus-workspace = 3; })
              // (mkBindVal "Mod+4" { focus-workspace = 4; })
              // (mkBindVal "Mod+5" { focus-workspace = 5; })
              // (mkBindVal "Mod+6" { focus-workspace = 6; })
              // (mkBindVal "Mod+7" { focus-workspace = 7; })
              // (mkBindVal "Mod+8" { focus-workspace = 8; })
              // (mkBindVal "Mod+9" { focus-workspace = 9; })
              // (mkBindVal "Mod+Ctrl+1" { move-column-to-workspace = 1; })
              // (mkBindVal "Mod+Ctrl+2" { move-column-to-workspace = 2; })
              // (mkBindVal "Mod+Ctrl+3" { move-column-to-workspace = 3; })
              // (mkBindVal "Mod+Ctrl+4" { move-column-to-workspace = 4; })
              // (mkBindVal "Mod+Ctrl+5" { move-column-to-workspace = 5; })
              // (mkBindVal "Mod+Ctrl+6" { move-column-to-workspace = 6; })
              // (mkBindVal "Mod+Ctrl+7" { move-column-to-workspace = 7; })
              // (mkBindVal "Mod+Ctrl+8" { move-column-to-workspace = 8; })
              // (mkBindVal "Mod+Ctrl+9" { move-column-to-workspace = 9; })
              //

                (mkBind "Mod+Tab" "focus-workspace-previous")
              //

                (mkBind "Mod+BracketLeft" "consume-or-expel-window-left")
              // (mkBind "Mod+BracketRight" "consume-or-expel-window-right")
              //

                (mkBind "Mod+Comma" "consume-window-into-column")
              // (mkBind "Mod+Period" "expel-window-from-column")
              //

                (mkBind "Mod+R" "switch-preset-column-width")
              // (mkBind "Mod+Shift+R" "switch-preset-window-height")
              // (mkBind "Mod+Ctrl+R" "reset-window-height")
              // (mkBind "Mod+F" "maximize-column")
              // (mkBind "Mod+Shift+F" "fullscreen-window")
              //

                (mkBind "Mod+Ctrl+F" "expand-column-to-available-width")
              //

                (mkBind "Mod+C" "center-column")
              //

                (mkBind "Mod+Ctrl+C" "center-visible-columns")
              //

                (mkBindVal "Mod+Minus" { set-column-width = "-10%"; })
              // (mkBindVal "Mod+Equal" { set-column-width = "+10%"; })
              //

                (mkBindVal "Mod+Shift+Minus" { set-window-height = "-10%"; })
              // (mkBindVal "Mod+Shift+Equal" { set-window-height = "+10%"; })
              //

                (mkBind "Mod+V" "toggle-window-floating")
              // (mkBind "Mod+Shift+V" "switch-focus-between-floating-and-tiling")
              //

                (mkBind "Mod+W" "toggle-column-tabbed-display")
              //

                (mkBind "Print" "screenshot")
              // (mkBind "Ctrl+Print" "screenshot-screen")
              // (mkBind "Alt+Print" "screenshot-window")
              //

                (mkBindProps "Mod+Escape" "toggle-keyboard-shortcuts-inhibit" { allow-inhibiting = false; })
              //

                (mkBind "Mod+Shift+E" "quit")
              // (mkBind "Ctrl+Alt+Delete" "quit")
              //

                (mkBind "Mod+Shift+P" "power-off-monitors");
          };
      };
    };
}

#flake.modules.homeManager.desktop-niri =
#  {
#    config,
#    pkgs,
#    lib,
#    ...
#  }:
#  let
#    inherit (config.systemConstants.keyboard) xkb;
#    inherit (config.systemConstants.keyboard) repeatDelay;
#    inherit (config.systemConstants.keyboard) repeatRate;
#    userBinds = builtins.map (
#      bind:
#      let
#        # TODO make it more foolproof, check types
#        prefix = if bind.mod == "" then "" else "${bind.mod}+";
#        extraModsGen =
#          extras:
#          builtins.concatStringsSep " " (
#            builtins.map (
#              n:
#              if n == "locked" then
#                "allow-when-locked=${lib.boolToString extras.locked}"
#              else if n == "description" then
#                "hotkey-overlay-title=\"${extras.description}\""
#              else
#                ""
#            ) (builtins.attrNames extras)
#          );
#      in
#      "${prefix}${builtins.concatStringsSep "+" bind.keys} ${extraModsGen bind.extras} { spawn-sh \"${bind.cmd}\"; }"
#    ) config.systemConstants.keyboard.binds;
#  in
#  {
#    #TODO output settings
#    # spawn-at-startup "ashell"
#    # spawn-at-startup "ghostty"
#    xdg.configFile."niri/config.kdl".text = ''
#      screenshot-path "~/Pictures/screenshot_%Y-%m-%d %H-%M-%S.png"
#      prefer-no-csd

#      spawn-sh-at-startup "systemctl --user stop wl-session.target"
#      spawn-sh-at-startup "systemctl --user start wl-session.target"

#      cursor {
#        xcursor-theme "Bibata-Modern-Ice"
#        xcursor-size 32

#        hide-when-typing
#        hide-after-inactive-ms 1000
#      }

#      input {
#        focus-follows-mouse max-scroll-amount="0%"

#        keyboard {
#          xkb {
#            layout "${xkb.layout}"
#            variant "${xkb.variant}"
#            options "${xkb.options}"
#          }
#          repeat-delay ${builtins.toString repeatDelay}
#          repeat-rate ${builtins.toString repeatRate}
#          track-layout "global"
#        }
#        touchpad {
#          tap
#          dwt
#          accel-speed 0.2
#          accel-profile "flat"
#          scroll-method "two-finger"
#        }
#        mouse {
#          // off
#          // natural-scroll
#          accel-speed 1.0
#          accel-profile "flat"
#          scroll-method "no-scroll"
#        }
#      }

#      layout {
#        gaps 15
#        center-focused-column "never"

#        default-column-width { proportion 0.43; }
#        preset-column-widths {
#          proportion 0.33333
#          proportion 0.5
#          proportion 0.66667
#        }
#        focus-ring {
#          width 4
#          active-color "#7fc8ff"
#          inactive-color "#505050"
#        }
#        tab-indicator {
#          on
#          hide-when-single-tab
#          place-within-column
#          gap 5
#          width 4
#          length total-proportion=1.0
#          position "right"
#          gaps-between-tabs 2
#          corner-radius 8
#          active-color "red"
#          inactive-color "gray"
#          urgent-color "blue"
#        }
#        insert-hint {
#          on
#          color "#ffc87f80"
#        }
#        struts {
#          // left 64
#          // right 64
#          // top 64
#          // bottom 64
#        }
#      }
#      hotkey-overlay {
#        // Uncomment this line to disable the "Important Hotkeys" pop-up at startup.
#        skip-at-startup
#      }
#      animations {
#        off
#      }
#      window-rule {
#        match app-id=r#"firefox$"# title="^Picture-in-Picture$"
#        open-floating true
#      }
#      window-rule {
#        match app-id=r#"^org\.keepassxc\.KeePassXC$"#
#        match app-id=r#"^org\.gnome\.World\.Secrets$"#

#        block-out-from "screen-capture"
#      }

#      // Example: enable rounded corners for all windows.
#      // (This example rule is commented out with a "/-" in front.)
#      /-window-rule {
#        geometry-corner-radius 12
#        clip-to-geometry true
#      }

#      binds {
#      // `niri msg action do-something`.

#        Mod+Shift+Slash { show-hotkey-overlay; }
#        ${builtins.concatStringsSep "\n\t" userBinds}

#        Mod+O repeat=false { toggle-overview; }

#        Mod+Q repeat=false { close-window; }

#        Mod+Left  { focus-column-left; }
#        Mod+Down  { focus-window-down; }
#        Mod+Up    { focus-window-up; }
#        Mod+Right { focus-column-right; }
#        Mod+H     { focus-column-left; }
#        Mod+J     { focus-window-down; }
#        Mod+K     { focus-window-up; }
#        Mod+L     { focus-column-right; }

#        Mod+Ctrl+Left  { move-column-left; }
#        Mod+Ctrl+Down  { move-window-down; }
#        Mod+Ctrl+Up    { move-window-up; }
#        Mod+Ctrl+Right { move-column-right; }
#        Mod+Ctrl+H     { move-column-left; }
#        Mod+Ctrl+J     { move-window-down; }
#        Mod+Ctrl+K     { move-window-up; }
#        Mod+Ctrl+L     { move-column-right; }

#        // Alternative commands that move across workspaces when reaching
#        // the first or last window in a column.
#        // Mod+J     { focus-window-or-workspace-down; }
#        // Mod+K     { focus-window-or-workspace-up; }
#        // Mod+Ctrl+J     { move-window-down-or-to-workspace-down; }
#        // Mod+Ctrl+K     { move-window-up-or-to-workspace-up; }

#        Mod+Home { focus-column-first; }
#        Mod+End  { focus-column-last; }
#        Mod+Ctrl+Home { move-column-to-first; }
#        Mod+Ctrl+End  { move-column-to-last; }

#        Mod+Shift+Left  { focus-monitor-left; }
#        Mod+Shift+Down  { focus-monitor-down; }
#        Mod+Shift+Up    { focus-monitor-up; }
#        Mod+Shift+Right { focus-monitor-right; }
#        Mod+Shift+H     { focus-monitor-left; }
#        Mod+Shift+J     { focus-monitor-down; }
#        Mod+Shift+K     { focus-monitor-up; }
#        Mod+Shift+L     { focus-monitor-right; }

#        Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
#        Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
#        Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
#        Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
#        Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
#        Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
#        Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
#        Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

#        Mod+Page_Down      { focus-workspace-down; }
#        Mod+Page_Up        { focus-workspace-up; }
#        Mod+U              { focus-workspace-down; }
#        Mod+I              { focus-workspace-up; }
#        Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
#        Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
#        Mod+Ctrl+U         { move-column-to-workspace-down; }
#        Mod+Ctrl+I         { move-column-to-workspace-up; }

#        Mod+Shift+Page_Down { move-workspace-down; }
#        Mod+Shift+Page_Up   { move-workspace-up; }
#        Mod+Shift+U         { move-workspace-down; }
#        Mod+Shift+I         { move-workspace-up; }

#        Mod+WheelScrollDown      cooldown-ms=150 { focus-column-right; }
#        Mod+WheelScrollUp        cooldown-ms=150 { focus-column-left; }
#        Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
#        Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

#        Mod+WheelScrollRight      { focus-column-right; }
#        Mod+WheelScrollLeft       { focus-column-left; }
#        Mod+Ctrl+WheelScrollRight { move-column-right; }
#        Mod+Ctrl+WheelScrollLeft  { move-column-left; }

#        Mod+Shift+WheelScrollDown      { focus-workspace-down; }
#        Mod+Shift+WheelScrollUp        { focus-workspace-up; }
#        Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
#        Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

#        Mod+1 { focus-workspace 1; }
#        Mod+2 { focus-workspace 2; }
#        Mod+3 { focus-workspace 3; }
#        Mod+4 { focus-workspace 4; }
#        Mod+5 { focus-workspace 5; }
#        Mod+6 { focus-workspace 6; }
#        Mod+7 { focus-workspace 7; }
#        Mod+8 { focus-workspace 8; }
#        Mod+9 { focus-workspace 9; }
#        Mod+Ctrl+1 { move-column-to-workspace 1; }
#        Mod+Ctrl+2 { move-column-to-workspace 2; }
#        Mod+Ctrl+3 { move-column-to-workspace 3; }
#        Mod+Ctrl+4 { move-column-to-workspace 4; }
#        Mod+Ctrl+5 { move-column-to-workspace 5; }
#        Mod+Ctrl+6 { move-column-to-workspace 6; }
#        Mod+Ctrl+7 { move-column-to-workspace 7; }
#        Mod+Ctrl+8 { move-column-to-workspace 8; }
#        Mod+Ctrl+9 { move-column-to-workspace 9; }

#        Mod+Tab { focus-workspace-previous; }

#        Mod+BracketLeft  { consume-or-expel-window-left; }
#        Mod+BracketRight { consume-or-expel-window-right; }

#        Mod+Comma  { consume-window-into-column; }
#        Mod+Period { expel-window-from-column; }

#        Mod+R { switch-preset-column-width; }
#        Mod+Shift+R { switch-preset-window-height; }
#        Mod+Ctrl+R { reset-window-height; }
#        Mod+F { maximize-column; }
#        Mod+Shift+F { fullscreen-window; }

#        Mod+Ctrl+F { expand-column-to-available-width; }

#        Mod+C { center-column; }

#        Mod+Ctrl+C { center-visible-columns; }

#        Mod+Minus { set-column-width "-10%"; }
#        Mod+Equal { set-column-width "+10%"; }

#        Mod+Shift+Minus { set-window-height "-10%"; }
#        Mod+Shift+Equal { set-window-height "+10%"; }

#        Mod+V       { toggle-window-floating; }
#        Mod+Shift+V { switch-focus-between-floating-and-tiling; }

#        Mod+W { toggle-column-tabbed-display; }

#        Print { screenshot; }
#        Ctrl+Print { screenshot-screen; }
#        Alt+Print { screenshot-window; }

#        Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

#        Mod+Shift+E { quit; }
#        Ctrl+Alt+Delete { quit; }

#        Mod+Shift+P { power-off-monitors; }
#      }
#    '';
#  };
#}
