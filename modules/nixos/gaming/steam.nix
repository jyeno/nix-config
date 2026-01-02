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
      default = gaming.enable;
      description = "Enable steam configuration";
    };
    extraEnv = lib.mkOption {
      type = lib.types.nullOr lib.types.attrs;
      default = {
        MANGOHUD = gaming.settings.mangohud.enable && ! gaming.gamescope.enable;
        MANGOHUD_CONFIG = gaming.settings.mangohud.configStr;
        ENABLE_VKBASALT = gaming.settings.vkbasalt.enable;
        PROTON_USE_NTSYNC = gaming.settings.ntsync.enable;
        PROTON_USE_WOW64 = gaming.settings.wow64.enable;
        PROTON_ENABLE_HDR = gaming.settings.hdr.enable;
        PROTON_ENABLE_WAYLAND = gaming.settings.wayland.enable;
        PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES = true; #temp
      };
      description = lib.literalExpression "Env vars to insert into steam package environment";
    };
    compatPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [pkgs.proton-ge-bin];
      description = lib.literalExpression "List of extra compatibility packages like proton-ge";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = lib.mkDefault true;
      package = pkgs.steam.override {
        extraEnv = cfg.extraEnv;
        extraProfile = ''
          unset TZ
        '';
      };
      remotePlay.openFirewall = lib.mkDefault true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = lib.mkDefault true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = lib.mkDefault true;
      gamescopeSession.enable = lib.mkDefault true;
      protontricks.enable = lib.mkDefault true;
      extraCompatPackages = cfg.compatPackages;
    };
  };
}
