{
  config,
  lib,
  ...
}: let
  cfg = config.local.home.desktop.ghostty;
in {
  options.local.home.desktop.ghostty = {
    enable = lib.mkEnableOption "Enable ghostty configuration";
  };
  config = lib.mkIf cfg.enable {
    #TODO add more options
    xdg.configFile."ghostty/config" = {
      text = ''
        # misc
        mouse-hide-while-typing = true
        window-save-state = always
        gtk-titlebar = false
        window-decoration = false
        shell-integration = fish
        theme = catppuccin-mocha
        # theme = GruvboxDarkHard
        copy-on-select = true

        # keybindings for panes/splits
        keybind = ctrl+s>\=new_split:right
        keybind = ctrl+s>-=new_split:down
        keybind = ctrl+s>x=close_surface

        # navigation between splits
        keybind = ctrl+s>h=goto_split:left
        keybind = ctrl+s>j=goto_split:bottom
        keybind = ctrl+s>k=goto_split:top
        keybind = ctrl+s>l=goto_split:right

        # tab management
        keybind = ctrl+shift+left=previous_tab
        keybind = ctrl+shift+right=next_tab
        keybind = ctrl+s>c=new_tab

        # quick tab switching
        keybind = ctrl+s>1=goto_tab:1
        keybind = ctrl+s>2=goto_tab:2
        keybind = ctrl+s>3=goto_tab:3
        keybind = ctrl+s>4=goto_tab:4
        keybind = ctrl+s>5=goto_tab:5
        keybind = ctrl+s>6=goto_tab:6
        keybind = ctrl+s>7=goto_tab:7
        keybind = ctrl+s>8=goto_tab:8
        keybind = ctrl+s>9=goto_tab:9
      '';
    };
  };
}
