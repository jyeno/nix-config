{
  flake.modules.nixos.nirvana = {
    networking =
      let
        portsFrom = 25500;
        portsTo = 25500;
      in
      {
        hostName = "nirvana";
        domain = "jyeno.cc";
        nameservers = [
          "8.8.8.8"
          "1.1.1.1"
        ];
        interfaces.eth0 = {
          ipv4.addresses = [
            {
              address = "10.0.0.90";
              prefixLength = 24;
            }
          ];
          useDHCP = true;
        };
        firewall = {
          enable = true;
          allowedTCPPorts = [ 22 ];
          allowedTCPPortRanges = [
            {
              from = portsFrom;
              to = portsTo;
            }
          ];
          allowedUDPPortRanges = [
            {
              from = portsFrom;
              to = portsTo;
            }
          ];
          logRefusedConnections = false;
          rejectPackets = true;
        };
      };
  };
}
