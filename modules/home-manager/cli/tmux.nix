{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.home.cli.tmux;
in {
  options.local.home.cli.tmux = {
    enable = lib.mkEnableOption "Enable tmux configuration";
    prefix = lib.mkOption {
      type = lib.types.str;
      default = "C-a";
      description = "tmux prefix setting";
    };
    keyMode = lib.mkOption {
      type = lib.types.str;
      default = "vi";
      description = "tmux keyMode setting";
    };
    historyLimit = lib.mkOption {
      type = lib.types.int;
      default = 100000;
      description = "tmux historyLimit setting";
    };
    clock24 = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "tmux clock24 setting";
    };
    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = with pkgs; [
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavour 'frappe'
            set -g @catppuccin_window_tabs_enabled on
            set -g @catppuccin_date_time "%H:%M"
          '';
        }
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-nvim 'session'";
            set -g @resurrect-capture-pane-contents 'on'
          '';
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-boot 'on'
            set -g @continuum-save-interval '10' # minutes
          '';
        }
        tmuxPlugins.yank
      ];
      description = "tmux plugins settings";
    };
  };
  config = lib.mkIf cfg.enable {
    #TODO add more options
    programs.tmux = {
      enable = lib.mkDefault true;
      prefix = cfg.prefix;
      shell = "${pkgs.fish}/bin/fish";
      terminal = lib.mkDefault "tmux-256color";
      clock24 = cfg.clock24;
      historyLimit = cfg.historyLimit;
      keyMode = cfg.keyMode;
      newSession = true;
      plugins = cfg.plugins;
    };
  };
}
