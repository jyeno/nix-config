{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.local.misc.sops;
  secretspath = builtins.toString inputs.nix-secrets;
in {
  options.local.misc.sops = {
    enable = lib.mkEnableOption "Enable SOPS configuration";
  };
  config = lib.mkIf cfg.enable {
    sops = {
      defaultSopsFile = "${secretspath}/secrets.yaml";

      age = {
        sshKeyPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];
        keyFile = "/var/lib/sops-nix/keys.txt";
        generateKey = true;
      };
      secrets.jyeno-password.neededForUsers = true; # TODO fix, it shouldnt be here
    };
    users.users.jyeno = {
      hashedPasswordFile = config.sops.secrets.jyeno-password.path;
    };
  };
}
