{
  config,
  lib,
  pkgs,
  ...
}: let
  service = config.local.service;
  cfg = service.podman;
  dockerEnabled = service.docker.enable;
in {
  options.local.service.podman.enable = lib.mkEnableOption "Enable Podman configuration";
  config = lib.mkIf cfg.enable {
    virtualisation = {
      oci-containers.backend = "podman";
      containers = {
        enable = true;
        registries.search = ["docker.io"];
      };
      podman = {
        enable = lib.mkDefault true;
        autoPrune.enable = true;
        dockerCompat = !dockerEnabled;
        dockerSocket.enable = !dockerEnabled;
        defaultNetwork.settings.dns_enabled = true;
        extraPackages = [pkgs.podman-compose];
      };
    };
  };
}
