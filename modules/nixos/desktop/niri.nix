{
  config,
  lib,
  ...
}: let
  cfg = config.local.desktop.niri;
in {
  options.local.desktop.niri.enable = lib.mkEnableOption "Enable niri configuration";
  config = lib.mkIf cfg.enable {
    programs.niri = {
      enable = true;
    };
  };
}
