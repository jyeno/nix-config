{
  flake.modules.nixos.gaming-gamescope = {
    programs.gamescope = {
      enable = true;
      # outputWidth = 3440;
      # outputHeight = 1440;
      # nestedRefresh = 165;
      # nestedUnfocusedRefresh = 30;
      # hdrItmSdrNits = 101;
      # hdrItmTargetNits = 400;
      # hdrSdrContentNits = 250;
      # sdrGamutWideness = 0.5;
      args = [
        # "-f"
        "-S fit"
        "--rt"
        "--immediate-flips"
        #"--force-composition"
      ];
    };
    # package = pkgs.gamescope;
    # args =
    #   (mkGamescopeFlag "rt" cfg.realtimePriority)
    #   ++ (mkGamescopeFlag "mangoapp" (gaming.settings.mangohud.enable && cfg.enableMangoHudIntegration))
    #   ++ (mkGamescopeFlag "fullscreen" cfg.fullscreen)
    #   ++ (mkGamescopeFlag "adaptive-sync" cfg.adaptiveSync)
    #   ++ (mkGamescopeFlag "immediate-flips" cfg.immediateFlips)
    #   ++ (mkGamescopeFlag "force-grab-cursor" cfg.forceGrabCursor)
    #   ++ (lib.optional (cfg.outputWidth != null) (
    #     mkGamescopeArg "output-width" cfg.outputWidth
    #   ))
    #   ++ (lib.optional (cfg.outputHeight != null) (
    #     mkGamescopeArg "output-height" cfg.outputHeight
    #   ))
    #   ++ (lib.optional (cfg.nestedWidth != null) (
    #     mkGamescopeArg "nested-width" cfg.nestedWidth
    #   ))
    #   ++ (lib.optional (cfg.nestedHeight != null) (
    #     mkGamescopeArg "nested-height" cfg.nestedHeight
    #   ))
    #   ++ (lib.optional (cfg.nestedRefresh != null) (
    #     mkGamescopeArg "nested-refresh" cfg.nestedRefresh
    #   ))
    #   ++ (lib.optional (cfg.nestedUnfocusedRefresh != null) (
    #     mkGamescopeArg "nested-unfocused-refresh" cfg.nestedUnfocusedRefresh
    #   ))
    #   ++ (lib.optionals cfg.hdrEnable (
    #     [
    #       "--hdr-enabled"
    #     ]
    #     ++ (lib.optional (cfg.hdrSdrContentNits != null) (
    #       mkGamescopeArg "hdr-sdr-content-nits" cfg.hdrSdrContentNits
    #     ))
    #     ++ (lib.optional (cfg.sdrGamutWideness != null) (
    #       mkGamescopeArg "sdr-gamut-wideness" cfg.sdrGamutWideness
    #     ))
    #   ))
    #   ++ (lib.optionals (cfg.hdrEnable && cfg.hdrItmEnable) (
    #     [
    #       "--hdr-itm-enable"
    #     ]
    #     ++ (lib.optional (cfg.hdrItmSdrNits != null) (
    #       mkGamescopeArg "hdr-itm-sdr-nits" cfg.hdrItmSdrNits
    #     ))
    #     ++ (lib.optional (cfg.hdrItmTargetNits != null) (
    #       mkGamescopeArg "hdr-itm-target-nits" cfg.hdrItmTargetNits
    #     ))
    #   ))
    #   ++ cfg.extraArgs;
    # env = lib.mkIf (gaming.settings.mangohud.enable && !cfg.enableMangoHudIntegration) {
    #   MANGOHUD = true;
    #   MANGOHUD_CONFIG = gaming.settings.mangohud.configStr;
    #   OBS_VKCAPTURE = true; # TODO move after obs capture option
    # };
  };
}
