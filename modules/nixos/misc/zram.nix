{
  config,
  lib,
  ...
}: let
  cfg = config.local.misc.zram;
in {
  options.local.misc.zram = {
    enable = lib.mkEnableOption "Enable cli root configuration";
    memoryPercent = lib.mkOption {
      type = lib.types.int;
      default = 200;
      description = "multiplier of zramswap module allocation";
    };
  };
  config = lib.mkIf cfg.enable {
    zramSwap = {
      enable = lib.mkDefault true;
      memoryPercent = cfg.memoryPercent;
    };
  };
}
