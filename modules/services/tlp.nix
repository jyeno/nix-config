{
  flake.modules.nixos.services-tlp = {
    services.power-profiles-daemon.enable = false;
    services.tlp.enable = true;
  };
}
