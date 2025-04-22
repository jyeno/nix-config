{
  config,
  lib,
  ...
}: let
  service = config.local.service;
  cfg = service.podman;
  dockerEnabled = service.docker.enable;
in {
  options.local.service.podman.enable = lib.mkEnableOption "Enable Podman configuration";
  config = lib.mkIf cfg.enable {
    virtualisation.podman = {
      enable = lib.mkDefault true;
      dockerCompat = !dockerEnabled;
      dockerSocket.enable = !dockerEnabled;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
