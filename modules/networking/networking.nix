{
  flake.modules.nixos.networking = {config, ...}: {
    networking = {
      # TODO improve, add more settings
      domain = "nirvana.jyeno.cc";
      firewall.enable = true;
      nftables.enable = true;
      nameservers = ["127.0.0.1" "1.1.1.1"];
      firewall.allowedTCPPorts = [22];
      firewall.allowedUDPPorts = [22];
    };
  };
}
