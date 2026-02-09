{
  flake.modules.nixos.services-openssh = {
    services = {
      openssh = {
        enable = true;
        # hostKeys = lib.optionals (builtins.length cfg.hostKeys > 0) cfg.hostKeys;
        hostKeys = [
          {
            path = "/persistent/etc/ssh/ssh_host_ed25519_key";
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
