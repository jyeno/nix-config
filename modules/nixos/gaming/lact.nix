{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.gaming.lact;
in {
  options.local.gaming.lact = {
    enable = lib.mkEnableOption "AMDGPU control software";
    overclock = lib.mkEnableOption "Enable overclock control";
    config = lib.mkOption {
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
    environment = {
      etc = lib.mkIf (cfg.config != {}) {
        "lact/config.yaml".source = (pkgs.formats.yaml {}).generate "lact-config" cfg.config;
        "modprobe.d/99-amdgpu-overdrive.conf".text = lib.mkIf cfg.overclock ''
          options amdgpu ppfeaturemask=0xFFF7FFFF
        '';
      };
      systemPackages = [pkgs.lact];
    };
    systemd.services.lactd = {
      enable = true;
      description = "AMDGPU Control Daemon";
      after = ["multi-user.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = "${pkgs.lact}/bin/lact daemon";
        Nice = -10;
        Restart = "on-failure";
      };
    };
  };
}
