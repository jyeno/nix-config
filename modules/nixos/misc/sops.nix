{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.local.misc.sops;
in {
  options.local.misc.sops = {
    enable = lib.mkEnableOption "Enable SOPS configuration";
  };
  config = lib.mkIf cfg.enable {
    sops = {
      defaultSopsFile = "${builtins.toString inputs.nix-secrets}/secrets.yaml";

      age = {
        sshKeyPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];
        keyFile = "/var/lib/sops-nix/keys.txt";
        generateKey = true;
      };
      secrets.jyeno-password.neededForUsers = true; # TODO fix, it shouldnt be here
      sops.secrets.root-password.neededForUsers = true;
    };
    users.users = {
      jyeno.hashedPasswordFile = config.sops.secrets.jyeno-password.path;
      root.hashedPasswordFile = config.sops.secrets.root-password.path;
    };
  };
}
