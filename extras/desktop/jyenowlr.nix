{pkgs, ...}: let
  lib = pkgs.lib;
  grimblast = lib.getExe pkgs.grimblast;
  # steam = lib.getExe pkgs.steam;
  telegram = lib.getExe pkgs.materialgram;
  light = lib.getExe pkgs.light;
  foot = lib.getExe' pkgs.foot "footclient";
  pactl = lib.getExe' pkgs.pulseaudio "pactl";
  defaultApp = type: "${pkgs.lib.getExe pkgs.handlr-regex} launch ${type}";
  terminal = lib.getExe pkgs.ghostty;
  pavucontrol = lib.getExe pkgs.pavucontrol;
  lockCmd = "${lib.getExe pkgs.hyprlock} &";
  clockFormat = "%a %d %b %R";
  launcher = lib.getExe pkgs.wofi;
  cliphist = lib.getExe pkgs.cliphist;
  clipboard = "selected=$(${cliphist} list | ${launcher} -S dmenu) && echo \"$selected\" | ${cliphist} decode | wl-copy";
  keybind = mod: key: cmd: "${mod}, ${key}, exec, ${cmd}";
in {
  river.enable = false;
  hyprland = {
    enable = true;
    extraConfig = ''
      monitor = DP-1, 3440x1440@165, 0x0, 1, bitdepth, 10, cm, hdr, sdrbrightness, 1.2, sdrsaturation, 0.98, vrr, 1
    '';
    keyboard = {
      layout = "us,us,us";
      variant = "intl,workman-intl,colemak_dh";
      options = "ctrl:nocaps,caps:ctrl_shifted_capslock,grp:win_space_toggle";
    };
    animations.enable = false;
    binds = {
      config = [
        # Program bindings
        (keybind "$mainMod" "Return" "${foot} sh -c 'tmux at -t 0 || tmux'")
        (keybind "$mainMod ALT" "Return" "${terminal}")
        # (keybind "$mainMod" "Return" "${defaultApp "x-scheme-handler/terminal"}")
        (keybind "$mainMod" "e" "${defaultApp "text/plain"}")
        (keybind "$mainMod" "b" "${defaultApp "x-scheme-handler/https"}")
        # (keybind "$mainMod" "s" "${steam}")
        (keybind "$mainMod" "t" "${telegram}")
        # Brightness control (only works if the system has lightd)
        (keybind "" "XF86MonBrightnessUp" "${light} -A 10")
        (keybind "" "XF86MonBrightnessDown" "${light} -U 10")
        # Volume
        (keybind "" "XF86AudioRaiseVolume" "${pactl} set-sink-volume @DEFAULT_SINK@ +5%")
        (keybind "" "XF86AudioLowerVolume" "${pactl} set-sink-volume @DEFAULT_SINK@ -5%")
        (keybind "" "XF86AudioMute" "${pactl} set-sink-mute @DEFAULT_SINK@ toggle")
        (keybind "SHIFT" "XF86AudioMute" "${pactl} set-source-mute @DEFAULT_SOURCE@ toggle")
        (keybind "" "XF86AudioMicMute" "${pactl} set-source-mute @DEFAULT_SOURCE@ toggle")
        # Screenshotting
        (keybind "" "Print" "${grimblast} --notify copy output")
        (keybind "$mainMod" "Print" "${grimblast} --notify copy area")
      ];
      enableCycleWorkspaces = true;
      enableExtraBinds = true;
    };
  };
  wlr = {
    enable = true;
    wofi.enable = true;
    fnott.enable = true;
    foot.enable = true;
    hypridle.enable = true;
    hyprlock.enable = true;
    # waybar.enable = false;
    # yambar.enable = false; #deprecated remove
    ashell = {
      enable = true;
      settings = let
        textCap = 150;
      in {
        log_level = "error";
        outputs = "All";
        position = "Bottom";
        app_launcher_cmd = launcher;
        clipboard_cmd = clipboard;
        truncate_title_after_length = textCap;
        modules = {
          left = [
            "AppLauncher"
            "Workspaces"
            "WindowTitle"
          ];
          center = ["MediaPlayer"];
          right = [
            "Tray"
            "SystemInfo"
            ["Clock" "Clipboard" "Privacy" "Settings"]
          ];
        };
        workspaces = {
          visibility_mode = "All";
          enable_workspace_filling = false;
        };
        system = {
          cpu_warn_threshold = 60;
          cpu_alert_threshold = 80;
          mem_warn_threshold = 70;
          mem_alert_threshold = 85;
          temp_warn_threshold = 60;
          temp_alert_threshold = 80;
        };

        clock.format = clockFormat;

        media_player.max_title_length = textCap;

        settings = {
          lock_cmd = lockCmd;
          audio_sinks_more_cmd = "${pavucontrol} -t 3";
          audio_sources_more_cmd = "${pavucontrol} -t 4";
          wifi_more_cmd = "${terminal} --command=iwctl";
          vpn_more_cmd = "${terminal} --command=iwctl";
          bluetooth_more_cmd = "${terminal} --command=bluetoothctl";
        };

        appearance = {
          style = "Islands";
          opacity = 1.0;
        };
      };
    };
  };
}
