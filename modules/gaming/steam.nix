{
  flake.modules.nixos.gaming-steam =
    {
      pkgs,
      ...
    }:
    {
      programs.steam = {
        enable = true;
        package = pkgs.steam.override {
          extraEnv = {
            MANGOHUD = true;
            MANGOHUD_CONFIG = "full,core_load=0";
            ENABLE_VKBASALT = false;
            PROTON_USE_NTSYNC = true;
            PROTON_ENABLE_HDR = true;
            PROTON_ENABLE_WAYLAND = true;
            PROTON_PREFER_SDL = true;
            PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES = true; # temp
            DXVK_HDR = true;
            PROTON_USE_WOW64 = true;
            PROTON_DXVK_LOWLATENCY = true;
            LOW_LATENCY_LAYER = true;
            PROTON_DISCORD_BRIDGE = true;
            SDL_AUDIODRIVER = "pipewire";
            SDL_VIDEODRIVER = "wayland";
          };
        };
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = true;
        protontricks.enable = true;
        extraCompatPackages = [
          pkgs.proton-ge-custom # cachyos packages
          pkgs.proton-cachyos_x86_64_v3
        ];
      };
    };
}
