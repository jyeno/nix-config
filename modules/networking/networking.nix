{
  flake.modules.nixos.networking = {
    config,
    lib,
    ...
  }: {
    networking = {
      # TODO improve, add more settings
      domain = lib.mkDefault "nirvana.jyeno.cc";
      firewall.enable = lib.mkDefault true;
      nftables.enable = lib.mkDefault true;
      nameservers = lib.mkDefault ["127.0.0.1" "1.1.1.1"];
      firewall.allowedTCPPorts = lib.mkDefault [22];
      firewall.allowedUDPPorts = lib.mkDefault [22];
    };
  };
}
