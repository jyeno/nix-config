{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.home.wayland.river;
in {
  options.local.home.wayland.river = {
    enable = lib.mkEnableOption "Enable riverwm configuration";
  };
  config = lib.mkIf cfg.enable {
    home.file.".wallpaper.png".source = ./wallpaper.png;

    xdg.portal = {
      xdgOpenUsePortal = true;
      enable = true;
      config = {
        common = {
          default = [
            "wlr"
          ];
        };
      };
      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    home.packages = with pkgs; [
      swaybg
      grimblast
      waylock
      river-bnf
      wlopm
      mpc-cli
    ];

    wayland.windowManager.river = let
      riverctl = lib.getExe' pkgs.river "riverctl";
      layout-manager = lib.getExe' pkgs.river "rivertile";
      change-tag = lib.getExe pkgs.river-bnf;
    in {
      enable = true;
      extraConfig = ''
        for i in $(seq 1 9)
        do
          tags=$((1 << ($i - 1)))

          # Super+[1-7] to focus tag [0-6]
          # Using river-bnf
          ${riverctl} map normal Super $i spawn "${change-tag} $tags"

          # Super+Shift+[1-9] to tag focused view with tag [0-8]
          ${riverctl} map normal Super+Shift $i set-view-tags $tags

          # Super+Ctrl+[1-9] to toggle focus of tag [0-8]
          ${riverctl} map normal Super+Control $i toggle-focused-tags $tags

          # Super+Shift+Ctrl+[1-9] to toggle tag [0-8] of focused view
          ${riverctl} map normal Super+Shift+Control $i toggle-view-tags $tags
        done

        # Super+0 to focus all tags
        # Super+Shift+0 to tag focused view with all tags
        all_tags=$(((1 << 9) - 1))
          ${riverctl} map normal Super 0 set-focused-tags $all_tags
          ${riverctl} map normal Super+Shift 0 set-view-tags $all_tags

          ${layout-manager} -view-padding 6 -outer-padding 6 &
          ${pkgs.swaybg}/bin/swaybg -i ~/.wallpaper.png --mode fill &
          ${riverctl} keyboard-layout -options "ctrl:nocaps,grp:win_space_toggle" 'us,us(workman-intl)'
      '';
      settings = {
        border-width = 2;
        default-layout = "rivertile";
        declare-mode = [
          "locked"
          "normal"
          "passthrough"
        ];
        focus-follows-cursor = "normal";
        hide-cursor = {
          when-typing = true;
        };
        input = {
          "pointer-1267-12541-ELAN0718:00_04F3:30FD_Touchpad" = {
            accel-profile = "flat";
            events = true;
            tap = true;
          };
        };
        map-pointer = {
          normal = {
            "Super BTN_RIGHT" = "resize-view";
            "Super BTN_MIDDLE" = "toggle-float";
            "Super BTN_LEFT" = "move-view";
          };
        };

        map = let
          grimblast = lib.getExe pkgs.grimblast;
          telegram = ""; #lib.getExe pkgs._64gram;
          light = lib.getExe pkgs.light;
          footclient = lib.getExe' pkgs.foot "footclient";
          tmux = lib.getExe pkgs.tmux;
          # foot = lib.getExe' pkgs.foot "foot";
          ghostty = lib.getExe pkgs.ghostty;
          # wpctl = lib.getExe pkgs.wireplumber "wpctl";
          pactl = lib.getExe' pkgs.pulseaudio "pactl";
          # notify-send = lib.getExe' pkgs.libnotify "notify-send";
          defaultApp = type: "${lib.getExe pkgs.handlr-regex} launch ${type}";
          chromium = lib.getExe config.programs.chromium.package;
          playerctl = lib.getExe' config.services.playerctld.package "playerctl";
          playerctld = lib.getExe' config.services.playerctld.package "playerctld";
          wofi = lib.getExe config.programs.wofi.package;
          cliphist = lib.getExe config.services.cliphist.package;
          wlopm = lib.getExe pkgs.wlopm;

          keybind = mode: keys: cmd: {
            name = "${mode} ${keys}";
            value = cmd;
          };
          keybind_spawn = mode: keys: cmd: keybind mode keys "spawn '${cmd}'";
          # TODO create a changing sink script to change sinks on demand
        in
          builtins.listToAttrs [
            (keybind_spawn "locked" "Super+Alt M" "${wlopm} --toggle DP-1")
            (keybind_spawn "normal" "Super+Alt M" "${wlopm} --toggle DP-1")
            (keybind_spawn "normal" "Super Return" "${footclient} ${tmux} new -t default -A")
            (keybind_spawn "normal" "Super+Alt Return" "${ghostty}")
            # (keybind_spawn "normal" "Super+Alt Return" "${foot} -a float")
            (keybind_spawn "normal" "Super B" "${defaultApp "x-scheme-handler/https"}")
            (keybind_spawn "normal" "Super+Shift B" "${chromium}")
            (keybind_spawn "normal" "Super T" "${telegram}")

            (keybind "normal" "Super+Shift Space" "toggle-float")
            (keybind "normal" "Super F" "toggle-fullscreen")
            (keybind "normal" "Alt Q" "close")
            (keybind "normal" "Super+Alt E" "exit")
            # View
            (keybind "normal" "Super J" "focus-view next")
            (keybind "normal" "Super K" "focus-view previous")
            (keybind "normal" "Super+Alt H" "move left 100")
            (keybind "normal" "Super+Alt J" "move down 100")
            (keybind "normal" "Super+Alt K" "move up 100")
            (keybind "normal" "Super+Alt L" "move right 100")
            (keybind "normal" "Super+Shift J" "swap next")
            (keybind "normal" "Super+Shift K" "swap previous")
            (keybind "normal" "Super Period" "focus-output next")
            (keybind "normal" "Super Comma" "focus-output previous")
            (keybind "normal" "Super+Shift Period" "send-to-output next")
            (keybind "normal" "Super+Shift Comma" "send-to-output previous")
            # Bump the focused view to the top of the layout stack
            (keybind "normal" "Super+Shift Return" "zoom")
            # snap view to the screen edges
            (keybind "normal" "Super+Alt+Control H" "snap left")
            (keybind "normal" "Super+Alt+Control J" "snap down")
            (keybind "normal" "Super+Alt+Control K" "snap up")
            (keybind "normal" "Super+Alt+Control L" "snap right")

            # Resize
            (keybind "normal" "Super+Alt+Shift H" "resize horizontal -100")
            (keybind "normal" "Super+Alt+Shift J" "resize vertical 100")
            (keybind "normal" "Super+Alt+Shift K" "resize vertical -100")
            (keybind "normal" "Super+Alt+Shift L" "resize horizontal 100")

            # Layout
            (keybind "normal" "Super H" "send-layout-cmd rivertile 'main-ratio -0.05'")
            (keybind "normal" "Super L" "send-layout-cmd rivertile 'main-ratio +0.05'")

            # To increment/decrement the main count of rivertile(1)
            (keybind "normal" "Super+Shift H" "send-layout-cmd rivertile 'main-count +1'")
            (keybind "normal" "Super+Shift L" "send-layout-cmd rivertile 'main-count -1'")

            # Brightness control (only works if the system has lightd)
            (keybind_spawn "normal" "None XF86MonBrightnessUp" "${light} -A 10")
            (keybind_spawn "normal" "None XF86MonBrightnessDown" "${light} -U 10")

            # Volume
            (keybind_spawn "normal" "None XF86AudioRaiseVolume" "${pactl} set-sink-volume @DEFAULT_SINK@ +5%")
            (keybind_spawn "normal" "None XF86AudioLowerVolume" "${pactl} set-sink-volume @DEFAULT_SINK@ -5%")
            (keybind_spawn "normal" "None XF86AudioMute" "${pactl} set-sink-mute @DEFAULT_SINK@ toggle")
            (keybind_spawn "normal" "Shift XF86AudioMute" "${pactl} set-source-mute @DEFAULT_SOURCE@ toggle")
            (keybind_spawn "normal" "None XF86AudioMicMute" "${pactl} set-source-mute @DEFAULT_SOURCE@ toggle")

            # Screenshotting
            (keybind_spawn "normal" "None Print" "${grimblast} --notify copy output")
            (keybind_spawn "normal" "Super Print" "${grimblast} --notify copy area")

            # Media control
            (keybind_spawn "normal" "None XF86AudioNext" "${playerctl} next")
            (keybind_spawn "normal" "None XF86AudioPrev" "${playerctl} previous")
            (keybind_spawn "normal" "None XF86AudioPlay" "${playerctl} play-pause")
            (keybind_spawn "normal" "None XF86AudioStop" "${playerctl} stop")
            (keybind_spawn "normal" "Alt XF86AudioNext" "${playerctld} shift")
            (keybind_spawn "normal" "Alt XF86AudioPrev" "${playerctld} unshift")
            (keybind_spawn "normal" "Alt XF86AudioPlay" "systemctl --user restart playerctld")

            # Menu
            (keybind_spawn "normal" "Super D" "${wofi} -S drun -x 10 -y 10 -W 25% -H 60%")
            (keybind_spawn "normal" "Super+Alt D" "${wofi} -S run")
            (keybind_spawn "normal" "Super C" "selected=$(${cliphist} list | ${wofi} -S dmenu) && echo \"$selected\" | ${cliphist} decode | wl-copy")
          ];

        rule-add = {
          "-app-id" = {
            "'firefox'" = "tags $((1 << (2 - 1)))";
            "'chromium-browser'" = "tags $((1 << (4 - 1)))";
            "'io.github.tdesktop_x64.TDesktop'" = "tags $((1 << (2 - 1)))";
            "'steam'" = "tags $((1 << (3 - 1)))";
            "'float'" = "float";
            "'mpv'" = "float";
            "'popup'" = "float";
            "'imv'" = "float";
            "'scrcpy'" = "float";
            "'org.pulseaudio.pavucontrol'" = "float";
            "'org.keepassxc.KeePassXC'" = "float";
            "'org.qt-project.qml'" = "float";
          };
          "-title" = {
            "'*is sharing*'" = "float";
            "'*Friends List*'" = "float";
            "'*Picture-in-Picture*'" = "float";
          };
        };
        set-cursor-warp = "on-output-change";
        set-repeat = "50 300";
        spawn = [];
        xcursor-theme = "Vimix-Cursors 24";
      };
    };
  };
}
