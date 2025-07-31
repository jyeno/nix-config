{
  config,
  lib,
  ...
}: let
  cfg = config.local.home.desktop.cliphist;
in {
  options.local.home.desktop.cliphist.enable = lib.mkEnableOption "Enable cliphist service";
  config = lib.mkIf cfg.enable {
    services.cliphist.enable = true;
  };
}
