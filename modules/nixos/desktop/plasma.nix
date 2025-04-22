{
  config,
  lib,
  ...
}: let
  cfg = config.local.desktop.plasma;
in {
  options.local.desktop.plasma.enable = lib.mkEnableOption "Enable Plasma6 configuration";
  config = lib.mkIf cfg.enable {
    services.desktopManager.plasma6.enable = true;
    services.displayManager = {
      defaultSession = "plasma";
      sddm.wayland.enable = true;
    };
  };
}
