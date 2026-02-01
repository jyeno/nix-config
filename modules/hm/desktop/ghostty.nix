{
  config,
  lib,
  ...
}: let
  cfg = config.local.home.desktop.ghostty;
in {
  options.local.home.desktop.ghostty = {
    enable = lib.mkEnableOption "Enable ghostty configuration";
    # settings = lib.mkOption {
    #   type = with lib.types; listOf attrs;
    #   default = {};
    #   description = "settings of ghostty";
    # };
  };
  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      systemd.enable = true;
      clearDefaultKeybinds = true; # builtins.hasAttr "keybind" cfg.settings; # check if cfg has a keybind
      enableFishIntegration = true; # check if fish is enabled
      settings = {
        mouse-hide-while-typing = true;
        copy-on-select = true;
        gtk-titlebar = false;
        gtk-tabs-location = "hidden";
        window-save-state = "always";
        window-decoration = "none";
        term = "xterm-256color";
        keybind = [
          # keybindings for panes/splits
          "ctrl+s>\=new_split:right"
          "ctrl+s>-=new_split:down"
          "ctrl+s>x=close_surface"
          "ctrl+s>enter=toggle_split_zoom"
          # navigation between splits
          "ctrl+s>h=goto_split:left"
          "ctrl+s>j=goto_split:bottom"
          "ctrl+s>k=goto_split:top"
          "ctrl+s>l=goto_split:right"
          # tab management
          "ctrl+shift+left=previous_tab"
          "ctrl+shift+right=next_tab"
          "ctrl+s>c=new_tab"
          # quick tab switching
          "ctrl+tab=next_tab"
          "ctrl+s>arrow_left=previous_tab"
          "ctrl+s>arrow_right=next_tab"
          "ctrl+s>1=goto_tab:1"
          "ctrl+s>2=goto_tab:2"
          "ctrl+s>3=goto_tab:3"
          "ctrl+s>4=goto_tab:4"
          "ctrl+s>5=goto_tab:5"
          "ctrl+s>6=goto_tab:6"
          "ctrl+s>7=goto_tab:7"
          "ctrl+s>8=goto_tab:8"
          "ctrl+s>9=goto_tab:9"
        ];
      };
    };
  };
}
