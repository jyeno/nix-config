{
  config,
  lib,
  pkgs,
  ...
}: let
  gaming = config.local.gaming;
  cfg = gaming.steam;
in {
  options.local.gaming.steam = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable steam configuration";
    };
    extraEnv = lib.mkOption {
      type = lib.types.nullOr lib.types.attrs;
      default = {
        MANGOHUD = gaming.settings.mangohud.enable && ! gaming.gamescope.enable;
        MANGOHUD_CONFIG = gaming.settings.mangohud.configStr;
        ENABLE_VKBASALT = gaming.settings.vkbasalt.enable;
        PROTON_USE_NTSYNC = gaming.settings.ntsync.enable;
        DXVK_HDR = gaming.settings.hdr.enable;
        PROTON_ENABLE_HDR = gaming.settings.hdr.enable;
        PROTON_ENABLE_WAYLAND = gaming.settings.wayland.enable;
        ENABLE_HDR_WSI = gaming.settings.hdr.enable;
        WINE_FULLSCREEN_FSR = true;
      };
      description = lib.literalExpression "Env vars to insert into steam package environment";
    };
    compatPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [pkgs.proton-ge-custom];
      description = lib.literalExpression "List of extra compatibility packages like proton-ge";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = lib.mkDefault true;
      package = lib.mkIf (cfg.extraEnv != null) (pkgs.steam.override {
        extraEnv = cfg.extraEnv;
        extraProfile = ''
          unset TZ
        '';
      });
      remotePlay.openFirewall = lib.mkDefault true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = lib.mkDefault true; # Open ports in the firewall for Source Dedicated Server
      gamescopeSession.enable = lib.mkDefault true;
      protontricks.enable = lib.mkDefault true;
      extraCompatPackages = cfg.compatPackages;
    };
  };
}
