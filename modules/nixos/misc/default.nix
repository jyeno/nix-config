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
    # ./networking.nix
    ./sops.nix
    ./virtualisation.nix
    ./zram.nix
  ];

  options.local.misc = {
    firewall = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable firewall configuration";
      };
      nameservers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["127.0.0.1" "1.1.1.1"];
        description = "firewall nameservers";
      };
    };
  };

  config.networking = {
    firewall.enable = cfg.firewall.enable;
    nameservers = cfg.firewall.nameservers;
  };
}
