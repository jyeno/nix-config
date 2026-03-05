{
  flake.modules.homeManager.desktop-idlelock =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      services.hypridle = {
        # TODO create script to dpms-on off
        enable = true;
        systemdTarget = "wl-session.target";
        settings =
          let
            hyprctl = lib.getExe' pkgs.hyprland "hyprctl";
            wlopm = lib.getExe pkgs.wlopm;
            niri = lib.getExe pkgs.niri;
            dpms-on-off = pkgs.writeShellScriptBin "dpms-on-off" ''
              state=$1
              if [[ "$state" != "on" && "$state" != "off" ]]; then
                exit 1
              fi
              compositor="unknown"
              if [[ "$HYPRLAND_INSTANCE_SIGNATURE" != "" ]]; then
                compositor="hyprland"
              elif [[ "$NIRI_SOCKET" != "" ]] || pgrep -x niri >/dev/null; then
                compositor="niri"
              elif pgrep -x river >/dev/null; then
                compositor="river"
              fi

              dpms_hyprland() {
                if [[ "$state" == "on" ]]; then
                  ${hyprctl} dispatch dpms on
                else
                  ${hyprctl} dispatch dpms off
                fi
              }

              dpms_wlopm() {
                if [[ "$state" == "on" ]]; then
                  ${wlopm} --on '*'
                else
                  ${wlopm} --off '*'
                fi
              }

              dpms_niri() {
                if [[ "$state" == "on" ]]; then
                  ${niri} msg output "DP-3" on
                else
                  ${niri} msg output "DP-3" off
                fi
              }

              case "$compositor" in
                hyprland)
                  dpms_hyprland
                  ;;
                niri)
                  dpms_niri
                  ;;
                river)
                  dpms_wlopm
                  ;;
                *)
                  echo "Unsupported or unknown compositor"
                  exit 1
                  ;;
              esac
            '';
            lock-cmd = "pidof hyprlock || hyprlock";
          in
          {
            general = {
              after_sleep_cmd = "${lib.getExe dpms-on-off} on";
              ignore_dbus_inhibit = false;
              lock_cmd = lock-cmd;
            };

            listener = [
              {
                timeout = 600;
                on-timeout = "hyprlock";
              }
              {
                timeout = 630;
                on-timeout = "${lib.getExe dpms-on-off} off";
                on-resume = "${lib.getExe dpms-on-off} on";
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
        };
      };
    };
}
