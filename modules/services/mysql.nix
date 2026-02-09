{
  flake.modules.nixos.services-mysql = {pkgs, ...}: {
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
  };
}
