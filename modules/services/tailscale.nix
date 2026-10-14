{
  flake.modules.nixos.services-tailscale =
    { lib, pkgs, ... }:
    {
      services.tailscale = {
        enable = true;
        useRoutingFeatures = lib.mkDefault "client";
        openFirewall = true;
        # extraUpFlags = [ "--login-server https://tailscale.m7.rs" ];
      };

      environment.systemPackages = [ pkgs.tailscale ];
    };
}
