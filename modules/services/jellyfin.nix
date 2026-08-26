{
  flake.modules.nixos.services-jellyfin = {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };
  };
}
