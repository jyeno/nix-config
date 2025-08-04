{
  config,
  lib,
  localLib,
  ...
}: let
  cfg = config.local.misc;
in {
  # imports = lib.attrsets.attrValues (localLib.discoverModules ./.);
  imports = [
    ./boot.nix
    ./locale.nix
    ./persistent.nix
    ./sops.nix
    ./virtualisation.nix
    ./zram.nix
  ];

  options.local.misc = {
    networking = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "interfaces networking setup";
    };
  };

  config.networking = lib.optionals (cfg.networking != {}) cfg.networking;
}
