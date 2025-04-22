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
        MANGOHUD = gaming.mangohud.enable; # && ! gaming.gamescope.enable
        MANGOHUD_CONFIG = gaming.mangohud.configStr;
        ENABLE_VKBASALT = gaming.vkbasalt.enable;
        PROTON_USE_NTSYNC = true;
        PROTON_ENABLE_WAYLAND = true;
        WINE_FULLSCREEN_FSR = true;
        DXVK_HDR = gaming.settings.hdr.enable;
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
      });
      remotePlay.openFirewall = lib.mkDefault true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = lib.mkDefault true; # Open ports in the firewall for Source Dedicated Server
      gamescopeSession.enable = lib.mkDefault true;
      protontricks.enable = lib.mkDefault true;
      extraCompatPackages = cfg.compatPackages;
    };
  };
}
