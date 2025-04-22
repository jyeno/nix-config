{
  config,
  lib,
  ...
}: let
  cfg = config.local.cli.fish;
in {
  options.local.cli.fish.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable fish shell";
  };
  config = lib.mkIf (cfg.enable && config.local.cli.enable) {
    programs.fish = {
      enable = lib.mkDefault true;
      vendor = {
        completions.enable = lib.mkDefault true;
        config.enable = lib.mkDefault true;
        functions.enable = lib.mkDefault true;
      };
    };
  };
}
