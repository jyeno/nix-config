{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.home.misc.sound;
in {
  options.local.home.misc.sound = {
    enable = lib.mkEnableOption "Enable easyeffects configuration";
  };
  config = lib.mkIf cfg.enable {
    # TODO change file placement, add more options
    services.easyeffects = {
      enable = true;
      preset = "mic_sound_filter";
    };
    home.file.".config/easyeffects/input/mic_sound_filter.json".source = ./mic_sound_filter.json;
    home.packages = [
      pkgs.deepfilternet
    ];
  };
}
