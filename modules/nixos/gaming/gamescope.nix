{
  config,
  lib,
  pkgs,
  ...
}: let
  gaming = config.local.gaming;
  cfg = gaming.gamescope;
  mkGamescopeArg = name: value: "--${name}=${toString value}";
  mkGamescopeFlag = name: enabled: lib.optional enabled "--${name}";
in {
  options.local.gaming.gamescope = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable gamescope configuration";
    };
    realtimePriority = lib.mkOption {
      type = lib.types.bool;
      default = gaming.settings.rt.enable;
      description = "Enable Gamescope realtime priority (--rt)";
    };
    enableMangoHudIntegration = lib.mkOption {
      type = lib.types.bool;
      default = gaming.mangohud.enable;
      defaultText = lib.literalExpression "config.local.gaming.mangohud.enable";
      description = "Enable MangoHUD integration (--mangoapp)";
    };
    fullscreen = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Run Gamescope in fullscreen (--fullscreen)";
    };
    adaptiveSync = lib.mkOption {
      type = lib.types.bool;
      default = gaming.settings.vrr.enable;
      defaultText = lib.literalExpression "config.local.gaming.settings.vrr.enable";
      description = "Enable adaptive sync (VRR) (--adaptive-sync)";
    };
    immediateFlips = lib.mkOption {
      type = lib.types.bool;
      default = gaming.settings.vrr.enable;
      defaultText = lib.literalExpression "config.local.gaming.settings.vrr.enable";
      description = "Enable immediate flips (--immediate-flips)";
    };
    forceGrabCursor = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Force cursor grabbing (--force-grab-cursor)";
    };
    outputWidth = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = "Gamescope output width (--output-width)";
    };
    outputHeight = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = "Gamescope output height (--output-height)";
    };
    nestedWidth = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = cfg.outputWidth;
      defaultText = lib.literalExpression "config.local.gaming.gamescope.outputWidth";
      description = "Gamescope nested (internal) width (--nested-width)";
    };
    nestedHeight = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = cfg.outputHeight;
      defaultText = lib.literalExpression "config.local.gaming.gamescope.outputHeight";
      description = "Gamescope nested (internal) height (--nested-height)";
    };
    nestedRefresh = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = "Gamescope nested (internal) refresh rate (--nested-refresh)";
    };
    nestedUnfocusedRefresh = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = "Gamescope nested refresh rate when unfocused (--nested-unfocused-refresh)";
    };
    hdrEnable = lib.mkOption {
      type = lib.types.bool;
      default = gaming.settings.hdr.enable;
      defaultText = lib.literalExpression "config.local.gaming.settings.hdr.enable";
      description = "Enable HDR (--hdr-enabled)";
    };
    hdrItmEnable = lib.mkOption {
      type = lib.types.bool;
      default = gaming.settings.hdr.enable;
      defaultText = lib.literalExpression "config.local.gaming.settings.hdr.enable";
      description = "Enable HDR Inverse Tone Mapping (--hdr-itm-enable)";
    };
    hdrItmSdrNits = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = "HDR ITM SDR nits (--hdr-itm-sdr-nits)";
    };
    hdrItmTargetNits = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = "HDR ITM target nits (--hdr-itm-target-nits)";
    };
    hdrSdrContentNits = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = "HDR SDR content nits (--hdr-sdr-content-nits)";
    };
    sdrGamutWideness = lib.mkOption {
      type = lib.types.nullOr lib.types.float;
      default = null;
      description = "SDR gamut wideness (--sdr-gamut-wideness)";
    };
    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Extra arbitrary arguments to pass to the Gamescope command";
      example = [
        "--prefer-vk-device=0"
        "--debug-overlay"
      ];
    };
  };
  config = lib.mkIf cfg.enable {
    programs.gamescope = {
      enable = lib.mkDefault true;
      package = lib.mkDefault pkgs.gamescope;
      args =
        (mkGamescopeFlag "rt" cfg.realtimePriority)
        ++ (mkGamescopeFlag "mangoapp" (gaming.mangohud.enable && cfg.enableMangoHudIntegration))
        ++ (mkGamescopeFlag "fullscreen" cfg.fullscreen)
        ++ (mkGamescopeFlag "adaptive-sync" cfg.adaptiveSync)
        ++ (mkGamescopeFlag "immediate-flips" cfg.immediateFlips)
        ++ (mkGamescopeFlag "force-grab-cursor" cfg.forceGrabCursor)
        ++ (lib.optional (cfg.outputWidth != null) (
          mkGamescopeArg "output-width" cfg.outputWidth
        ))
        ++ (lib.optional (cfg.outputHeight != null) (
          mkGamescopeArg "output-height" cfg.outputHeight
        ))
        ++ (lib.optional (cfg.nestedWidth != null) (
          mkGamescopeArg "nested-width" cfg.nestedWidth
        ))
        ++ (lib.optional (cfg.nestedHeight != null) (
          mkGamescopeArg "nested-height" cfg.nestedHeight
        ))
        ++ (lib.optional (cfg.nestedRefresh != null) (
          mkGamescopeArg "nested-refresh" cfg.nestedRefresh
        ))
        ++ (lib.optional (cfg.nestedUnfocusedRefresh != null) (
          mkGamescopeArg "nested-unfocused-refresh" cfg.nestedUnfocusedRefresh
        ))
        ++ (lib.optionals cfg.hdrEnable (
          [
            "--hdr-enabled"
          ]
          ++ (lib.optional (cfg.hdrSdrContentNits != null) (
            mkGamescopeArg "hdr-sdr-content-nits" cfg.hdrSdrContentNits
          ))
          ++ (lib.optional (cfg.sdrGamutWideness != null) (
            mkGamescopeArg "sdr-gamut-wideness" cfg.sdrGamutWideness
          ))
        ))
        ++ (lib.optionals (cfg.hdrEnable && cfg.hdrItmEnable) (
          [
            "--hdr-itm-enable"
          ]
          ++ (lib.optional (cfg.hdrItmSdrNits != null) (
            mkGamescopeArg "hdr-itm-sdr-nits" cfg.hdrItmSdrNits
          ))
          ++ (lib.optional (cfg.hdrItmTargetNits != null) (
            mkGamescopeArg "hdr-itm-target-nits" cfg.hdrItmTargetNits
          ))
        ))
        ++ cfg.extraArgs;
      env = lib.mkIf (gaming.mangohud.enable && !cfg.enableMangoHudIntegration) {
        MANGOHUD = true;
        MANGOHUD_CONFIG = gaming.mangohud.configStr;
        OBS_VKCAPTURE = true; # TODO move after obs capture option
      };
    };
  };
}
