{pkgs, ...}: let
  lib = pkgs.lib;
  grimblast = lib.getExe pkgs.grimblast;
  steam = lib.getExe pkgs.steam;
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
    enable = false;
    extraConfig = ''
      monitor = DP-1, 3440x1440@165, 0x0, 1, bitdepth, 10, cm, hdr, sdrbrightness, 1.2, sdrsaturation, 0.98, vrr, 1
    '';
    keyboard = {
      layout = "us,us";
      variant = ",workman-intl";
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
        (keybind "$mainMod" "s" "${steam}")
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
  #wlr = {
  #  enable = true;
  #  wofi.enable = true;
  #  fnott.enable = false;
  #  foot.enable = false;
  #  hypridle.enable = false;
  #  hyprlock.enable = false;
  #  gbar.enable = false;
  #  waybar.enable = false;
  #  yambar.enable = false;
  #  #TODO use the new hm module instead
  #  ashell = {
  #    enable = false;
  #    settings = let
  #      textCap = 150;
  #      fontName = "Comic Sans MS"; # TODO change
  #      backgroundColor = "#1e1e2e";
  #      primaryColor = "#fab387";
  #      secondaryColor = "#11111b";
  #      successColor = "#a6e3a1";
  #      dangerColor = "#f38ba8";
  #      textColor = "#f38ba8";
  #    in {
  #      logLevel = "WARN";
  #      outputs = "All";
  #      position = "Bottom";
  #      appLauncherCmd = launcher;
  #      clipboardCmd = clipboard;
  #      truncateTitleAfterLength = textCap;
  #      modules = {
  #        left = [
  #          "AppLauncher"
  #          "Workspaces"
  #          "WindowTitle"
  #        ];
  #        center = ["MediaPlayer"];
  #        right = [
  #          "Tray"
  #          "SystemInfo"
  #          ["Clock" "Clipboard" "Privacy" "Settings"]
  #        ];
  #      };
  #      workspaces = {
  #        visibilityMode = "All";
  #        enableWorkspaceFilling = false;
  #      };
  #      system = {
  #        cpuWarnThreshold = 60;
  #        cpuAlertThreshold = 80;
  #        memWarnThreshold = 70;
  #        memAlertThreshold = 85;
  #        tempWarnThreshold = 60;
  #        tempAlertThreshold = 80;
  #      };

  #      clock.format = clockFormat;

  #      mediaPlayer.maxTitleLength = textCap;

  #      settings = {
  #        lockCmd = lockCmd;
  #        audioSinksMoreCmd = "${pavucontrol} -t 3";
  #        audioSourcesMoreCmd = "${pavucontrol} -t 4";
  #        wifiMoreCmd = "${terminal} --command=iwctl";
  #        vpnMoreCmd = "${terminal} --command=iwctl";
  #        bluetoothMoreCmd = "${terminal} --command=bluetoothctl";
  #      };

  #      appearance = {
  #        fontName = fontName;
  #        style = "islands";
  #        opacity = 1.0;
  #        backgroundColor = backgroundColor;
  #        primaryColor = primaryColor;
  #        secondaryColor = secondaryColor;
  #        successColor = successColor;
  #        dangerColor = dangerColor;
  #        textColor = textColor;
  #        workspaceColors = [
  #          "#fab387"
  #          "#b4befe"
  #        ];
  #        specialWorkspaceColors = [
  #          "#a6e3a1"
  #          "#f38ba8"
  #        ];
  #      };
  #    };
  #  };
  #};
}
