{
  flake.modules.nixos.services-postgres = {
    services.postgresql.enable = true;
  };
}
