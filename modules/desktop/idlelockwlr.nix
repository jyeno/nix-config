{
  flake.modules.homeManager.desktop-idlelock = {
    pkgs,
    lib,
    config,
    ...
  }: {
    services.hypridle = {
      # TODO create script to dpms-on off
      enable = true;
      systemdTarget = "hyprland-session.target";
      settings = let
        hyprctl = lib.getExe' pkgs.hyprland "hyprctl";
        wlopm = lib.getExe pkgs.wlopm;
        isRiverEnabled = config.wayland.windowManager.river.enable; # TODO get running compositor and run the right command
        dpms-on =
          if isRiverEnabled
          then "${wlopm} --on DP-1"
          else "${hyprctl} dispatch dpms on"; # change it so it depends on what wayland compositor is being used
        dpms-off =
          if isRiverEnabled
          then "${wlopm} --off DP-1"
          else "${hyprctl} dispatch dpms off"; # change it so it depends on what wayland compositor is being used
        lock-cmd = "pidof hyprlock || hyprlock -fork-on-lock";
      in {
        general = {
          after_sleep_cmd = dpms-on;
          ignore_dbus_inhibit = false;
          lock_cmd = lock-cmd;
        };

        listener = [
          {
            timeout = 600;
            on-timeout = "hyprlock -fork-on-lock";
          }
          {
            timeout = 630;
            on-timeout = dpms-off;
            on-resume = dpms-on;
          }
          {
            timeout = 1200;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          ignore_empty_input = true;
          hide_cursor = true;
        };
        animations = {
          enabled = true;
          fade_in = {
            duration = 300;
            bezier = "easeOutQuint";
          };
          fade_out = {
            duration = 300;
            bezier = "easeOutQuint";
          };
        };
        # label = [
        # # TIME
        #   {
        #     monitor = {
        #       text = "cmd[update:30000] echo \"<b><big> $(date +\"%R\") </big></b>\"";
        #       color = "$text";
        #       font_size = 110;
        #       font_family = "$font";
        #       shadow_passes = 3;
        #       shadow_size = 3;

        #       position = "0, -100";
        #       halign = "center";
        #       valign = "top";
        #     };
        #   }
        #   # DATE
        #   {
        #     monitor = {
        #       text = "cmd[update:43200000] echo \"$(date +\"%A, %d %B %Y\")\"";
        #       color = "$text";
        #       font_size = 18;
        #       font_family = "$font";
        #       position = "0, -300";
        #       halign = "center";
        #       valign = "top";
        #     };
        #   }
        # ];
        # input-field = [
        #   {
        #     size = "300, 60";
        #     position = "0, -100";
        #     monitor = "";
        #     dots_center = true;
        #     dots_size = 0.2;
        #     dots_spacing = 0.4;
        #     fade_on_empty = false;
        #     outline_thickness = 5;
        #     placeholder_text = "<span foreground='#cdd6f4'><i>󰌾  Logged in as </i><span foreground='#cba6f7'>${config.home.username}</span></span>";
        #     shadow_passes = 2;
        #     halign = "center";
        #     valign = "center";
        #   }
        # ];
      };
    };
  };
}
