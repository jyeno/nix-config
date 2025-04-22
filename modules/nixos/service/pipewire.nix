{
  config,
  lib,
  ...
}: let
  cfg = config.local.service.pipewire;
in {
  options.local.service.pipewire.enable = lib.mkEnableOption "Enable pipewire configuration";
  config = lib.mkIf cfg.enable {
    security.rtkit.enable = lib.mkDefault true;
    services.pipewire = {
      enable = lib.mkDefault true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
