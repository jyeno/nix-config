{inputs, ...}: {
  flake.modules.nixos.services-openssh = {
    config,
    lib,
    ...
  }: {
    services = {
      openssh = {
        enable = true;
        hostKeys = inputs.self.lib.mkIfPersistence config [
          {
            path = "${config.systemConstants.persistDir}/etc/ssh/ssh_host_ed25519_key";
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
