{
  flake.modules.homeManager.desktop-ashell =
    {
      pkgs,
      lib,
      ...
    }:
    {
      programs.ashell = {
        enable = true;
        systemd = {
          enable = true;
          target = "wl-session.target";
        };
        settings =
          let
            ghostty = lib.getExe pkgs.ghostty;
            pavucontrol = lib.getExe pkgs.pavucontrol;
            lockCmd = "${lib.getExe pkgs.hyprlock} &";
            clockFormat = "%d/%m/%Y %I:%M %p";
            fuzzel = lib.getExe pkgs.fuzzel;
            cliphist = lib.getExe pkgs.cliphist;
            clipboard = "selected=$(${cliphist} list | ${fuzzel} -d) && echo \"$selected\" | ${cliphist} decode | wl-copy";
            textCap = 150;
          in
          {
            log_level = "error";
            outputs = "All";
            position = "Bottom";
            app_launcher_cmd = fuzzel;
            clipboard_cmd = clipboard;
            truncate_title_after_length = textCap;
            modules = {
              left = [
                "AppLauncher"
                "Workspaces"
                "WindowTitle"
              ];
              center = [ "MediaPlayer" ];
              right = [
                "Tray"
                "SystemInfo"
                [
                  "Clock"
                  "Clipboard"
                  "Privacy"
                  "Settings"
                ]
                "Tempo"
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

            tempo.clock_format = clockFormat;
            notifications = {
              format = "%H:%M";
              show_timestamps = true;
              show_bodies = true;
            };

            media_player.max_title_length = textCap;

            settings = {
              lock_cmd = lockCmd;
              audio_sinks_more_cmd = "${pavucontrol} -t 3";
              audio_sources_more_cmd = "${pavucontrol} -t 4";
              wifi_more_cmd = "${ghostty} -e iwctl";
              vpn_more_cmd = "${ghostty} -e iwctl";
              bluetooth_more_cmd = "${ghostty} --command=bluetoothctl";
              battery_format = "IconAndPercentage";
              peripheral_battery_format = "Icon";
              microphone_indicator_format = "IconAndPercentage";
              network_indicator_format = "IconAndPercentage";
              bluetooth_indicator_format = "Icon";
            };

            appearance = {
              style = "Islands";
              opacity = 1.0;
            };
          };
      };
    };
}
