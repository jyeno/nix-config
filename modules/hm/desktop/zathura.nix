{
  config,
  lib,
  ...
}: let
  cfg = config.local.home.desktop.zathura;
in {
  options.local.home.desktop.zathura = {
    enable = lib.mkEnableOption "Enable zathura configuration";
  };
  config = lib.mkIf cfg.enable {
    # TODO properly customize, add more options
    programs.zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
        recolor = true;
      };
    };
  };
}
