{ inputs, ... }:
{
  flake.modules.nixos.services-openssh =
    {
      config,
      lib,
      ...
    }:
    {
      networking.firewall.allowedTCPPorts = [ 22 ];
      services = {
        openssh = {
          enable = true;
          hostKeys =
            let
              # mkIfPersistence returns an empty {} in case of false
              keys = inputs.self.lib.mkIfPersistence config [
                {
                  path = "${config.systemConstants.persistDir}/etc/ssh/ssh_host_ed25519_key";
                  type = "ed25519";
                }
              ];
            in
            if keys != { } then
              keys
            else
              [
                {
                  path = "/etc/ssh/ssh_host_ed25519_key";
                  type = "ed25519";
                }
              ];
          settings = {
            PermitRootLogin = "no";
            PasswordAuthentication = false;
          };
        };
      };
    };
}
