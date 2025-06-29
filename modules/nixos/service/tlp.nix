{
  config,
  lib,
  ...
}: let
  cfg = config.local.service.tlp;
in {
  options.local.service.tlp.enable = lib.mkEnableOption "Enable TLP service";
  config = lib.mkIf cfg.enable {
    services.power-profiles-daemon.enable = lib.mkForce false;
    services.tlp.enable = lib.mkDefault true;
  };
}
