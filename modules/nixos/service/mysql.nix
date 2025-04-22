{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.service.mysql;
in {
  options.local.service.mysql.enable = lib.mkEnableOption "Enable MariaDB service";
  config = lib.mkIf cfg.enable {
    services.mysql = {
      enable = lib.mkDefault true;
      package = lib.mkDefault pkgs.mariadb;
    };
  };
}
