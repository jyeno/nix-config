{
  config,
  lib,
  ...
}: let
  cfg = config.local.home.wayland.cliphist;
in {
  options.local.home.wayland.cliphist.enable = lib.mkEnableOption "Enable cliphist service";
  config = lib.mkIf cfg.enable {
    services.cliphist.enable = true;
  };
}
