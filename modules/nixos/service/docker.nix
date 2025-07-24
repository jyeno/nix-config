{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.service.docker;
in {
  options.local.service.docker.enable = lib.mkEnableOption "Enable docker (rootless) unit";
  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = lib.mkDefault true;
      autoPrune.enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      extraPackages = [pkgs.docker-compose];
    };
  };
}
