{
  flake.modules.nixos.services-podman =
    {
      config,
      pkgs,
      ...
    }:
    let
      dockerEnabled = config.virtualisation.docker.enable;
    in
    {
      virtualisation = {
        oci-containers.backend = "podman";
        containers = {
          enable = true;
          registries.settings.search = [ "docker.io" ];
        };
        podman = {
          enable = true;
          autoPrune.enable = true;
          dockerCompat = !dockerEnabled;
          dockerSocket.enable = !dockerEnabled;
          defaultNetwork.settings.dns_enabled = true;
          extraPackages = [ pkgs.podman-compose ];
        };
      };
    };
}
