{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.local.home.misc.sops;
in {
  options.local.home.misc.sops = {
    enable = lib.mkEnableOption "Enable sops config";
  };
  config = lib.mkIf cfg.enable {
    sops = {
      age = {
        keyFile = "/home/jyeno/.config/sops/age/keys.txt";
        generateKey = true;
      };
      defaultSopsFile = "${builtins.toString inputs.nix-secrets}/secrets.yaml";

      secrets = {
        "private_keys/jyeno" = {
          path = "/home/jyeno/.ssh/id_ed25519";
        };
      };
    };
  };
}
