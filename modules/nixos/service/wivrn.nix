{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.service.wivrn;
in {
  options.local.service.wivrn = {
    enable = lib.mkEnableOption "Enable WiVRn service";
    autoStart = lib.mkEnableOption "Startup WiVRn service on boot";
    xrizer = lib.mkEnableOption "Use xrizer instead of openComposite";
    defaultRuntime = lib.mkEnableOption ''
      Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
      will automatically read this and work with WiVRn (Note: This does not currently
      apply for games run in Valve's Proton)
    '';
    json = lib.mkOption {
      type = lib.types.attrs;
      example = {
        scale = 0.5; # 1.0x foveation scaling
        bitrate = 100000000; # 100 Mb/s
        encoders = [
          {
            encoder = "vaapi";
            codec = "h265";
            width = 1.0;
            height = 1.0;
            offset_x = 0.0;
            offset_y = 0.0;
          }
        ];
        application = [pkgs.wlx-overlay-s];
      };
      default = {};
      description = "Config for WiVRn (https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md)";
    };
  };
  config = lib.mkIf cfg.enable {
    services.wivrn = {
      enable = true;
      openFirewall = lib.mkDefault true;
      highPriority = lib.mkDefault true;
      # steam.importOXRRuntimes = lib.mkDefault true; # Sets ‘PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES’ system-wide
      inherit (cfg) defaultRuntime autoStart;

      config = {
        enable = cfg.json != {};
        json =
          cfg.json
          // (
            if cfg.xrizer
            then {
              openvr-compat-path = "${pkgs.xrizer}/lib/xrizer";
            }
            else {}
          );
      };
    };
  };
}
