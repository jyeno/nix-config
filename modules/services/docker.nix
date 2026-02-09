{
  flake.modules.nixos.services-docker = {pkgs, ...}: {
    virtualisation.docker = {
      enable = true;
      autoPrune.enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      extraPackages = [pkgs.docker-compose];
    };
  };
}
