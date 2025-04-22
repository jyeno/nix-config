{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.desktop.graphics;
in {
  options.local.desktop.graphics = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable graphics configuration";
    };
    amd-initrd = lib.mkEnableOption "Enable AMDGPU initrd configuration";
    xkb = lib.mkOption {
      type = lib.types.attrs;
      default = {
        layout = "us";
        variant = "workman";
        options = "ctrl:nocaps";
      };
      description = "XKB configuration";
    };
    xkb-workman = lib.mkEnableOption "Enable xkb Workman layout";
  };
  config = lib.mkIf cfg.enable {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
      amdgpu.initrd.enable = lib.mkIf cfg.amd-initrd true;
    };

    services.xserver = {
      enable = true;
      xkb = cfg.xkb;
    };

    services.displayManager.sddm = {
      enable = lib.mkDefault true;
      wayland.enable = true;
    };

    environment.systemPackages = lib.mkDefault [
      (pkgs.wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [
          obs-backgroundremoval
          obs-pipewire-audio-capture
          obs-source-clone
          obs-vkcapture
        ];
      })
    ];
  };
}
