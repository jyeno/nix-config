{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.local.home.misc.sops;
  secretspath = builtins.toString inputs.nix-secrets;
in {
  options.local.home.misc.sops = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable sops config";
    };
  };
  config = lib.mkIf cfg.enable {
    sops = {
      age = {
        keyFile = "/home/jyeno/.config/sops/age/keys.txt";
        generateKey = true;
      };
      defaultSopsFile = "${secretspath}/secrets.yaml";

      secrets = {
        "private_keys/jyeno" = {
          path = "/home/jyeno/.ssh/id_ed25519";
        };
      };
    };
  };
}
