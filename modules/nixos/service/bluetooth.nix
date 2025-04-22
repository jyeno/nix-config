{
  config,
  lib,
  ...
}: let
  cfg = config.local.service.bluetooth;
in {
  options.local.service.bluetooth.enable = lib.mkEnableOption "Enable bluetooth";
  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = lib.mkDefault true;
      powerOnBoot = lib.mkDefault true;
      settings.General.Experimental = lib.mkDefault true;
    };
  };
}
