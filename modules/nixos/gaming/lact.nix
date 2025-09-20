{
  config,
  lib,
  ...
}: let
  cfg = config.local.gaming.lact;
in {
  options.local.gaming.lact = {
    enable = lib.mkEnableOption "AMDGPU control software";
    overclockAMD = lib.mkEnableOption "Enable AMD overclock control";
    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "Configuration passed to LACT.";
      default = {};
      example = {
        daemon = {
          log_level = "info";
          admin_groups = [
            "wheel"
            "sudo"
          ];
          disable_clocks_cleanup = false;
          apply_settings_timer = 5;
        };
        gpus = {};
      };
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.amdgpu.overdrive.enable = cfg.overclockAMD;
    services.lact = {
      enable = true;
      settings = cfg.settings;
    };
  };
}
