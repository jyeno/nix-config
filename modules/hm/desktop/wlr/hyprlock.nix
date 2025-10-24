{
  config,
  lib,
  ...
}: let
  wayland = config.local.home.desktop.wlr;
  cfg = wayland.hyprlock;
in {
  options.local.home.desktop.wlr.hyprlock = {
    enable = lib.mkEnableOption "Enable hyprlock configuration";
  };
  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          ignore_empty_input = true;
          hide_cursor = true;
        };
        # background = [
        #   {
        #     path = "screenshot";
        #     blur_passes = 3;
        #     blur_size = 8;
        #   }
        # ];
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
