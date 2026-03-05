{
  flake.modules.homeManager.desktop-easyeffects =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.deepfilternet
      ];
      services.easyeffects = {
        enable = true;
        preset = "micSoundFilter";
        extraPresets.micSoundFilter = builtins.fromJSON (builtins.readFile ./mic_sound_filter.json);
      };
    };
}
