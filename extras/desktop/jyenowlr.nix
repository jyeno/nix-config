{pkgs, ...}: let
  lib = pkgs.lib;
  terminal = lib.getExe pkgs.ghostty;
  pavucontrol = lib.getExe pkgs.pavucontrol;
  lockCmd = "${lib.getExe pkgs.hyprlock} &";
  clockFormat = "%a %d %b %R";
  launcher = lib.getExe pkgs.wofi;
  cliphist = lib.getExe pkgs.cliphist;
  clipboard = "selected=$(${cliphist} list | ${launcher} -S dmenu) && echo \"$selected\" | ${cliphist} decode | wl-copy";
in {
  river.enable = false;
  niri.enable = true;
  hyprland = {
    enable = false;
    extraConfig = ''
      monitor = DP-1, 3440x1440@165, 0x0, 1, bitdepth, 10, cm, hdr, sdrbrightness, 1.2, sdrsaturation, 0.98, vrr, 1
    '';
    animations.enable = false;
    binds = {
      enableCycleWorkspaces = true;
      enableExtraBinds = true;
    };
  };
  wlr = {
    enable = true;
    wofi.enable = true;
    fuzzel.enable = true;
    fnott.enable = true;
    foot.enable = false;
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
