{
  config,
  lib,
  ...
}: let
  cfg = config.local.misc.boot;
in {
  options.local.misc.boot.enable = lib.mkEnableOption "Enable systemd-boot configuration";
  config = lib.mkIf cfg.enable {
    boot.loader = {
      systemd-boot.enable = lib.mkDefault true;
      efi.canTouchEfiVariables = lib.mkDefault true;
    };
  };
}
