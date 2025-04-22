{
  config,
  lib,
  ...
}: let
  cfg = config.local.service.postgres;
in {
  options.local.service.postgres.enable = lib.mkEnableOption "Enable postgresql configuration";
  config = lib.mkIf cfg.enable {
    services.postgresql.enable = lib.mkDefault true;
  };
}
