{
  config,
  lib,
  ...
}: let
  cfg = config.local.tweaks.nix;
in {
  options.local.tweaks.nix = {
    enable = lib.mkEnableOption "Enable nix tweaks configuration";
  };
  config = lib.mkIf cfg.enable {
    nix = {
      optimise.automatic = lib.mkDefault true;
      settings = {
        warn-dirty = lib.mkDefault true;
        auto-optimise-store = false;
        experimental-features = ["nix-command" "flakes" "pipe-operators"];
        substituters = [
          "https://nix-community.cachix.org"
          "https://attic.xuyh0120.win/lantian"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        ];
      };
      gc = {
        automatic = lib.mkDefault true;
        dates = lib.mkDefault "weekly";
        options = lib.mkDefault "--delete-older-than 7d";
      };
    };
  };
}
