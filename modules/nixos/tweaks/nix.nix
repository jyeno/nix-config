{
  config,
  lib,
  ...
}: let
  cfg = config.local.tweaks.nix;
in {
  options.local.tweaks.nix = {
    enable = lib.mkEnableOption "Enable nix tweaks configuration";
    allowUnfree = lib.mkEnableOption "Allow unfree software";
  };
  config = lib.mkIf cfg.enable {
    nixpkgs.config = {
      allowUnfree = cfg.allowUnfree;
      allowUnfreePredicate = _: cfg.allowUnfree;
    };

    nix = {
      optimise.automatic = lib.mkDefault true;
      settings = {
        warn-dirty = lib.mkDefault true;
        auto-optimise-store = false;
        experimental-features = ["nix-command" "flakes"];
        # hyprland cachix server
        substituters = ["https://hyprland.cachix.org"];
        trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
        extra-substituters = ["https://cache.lix.systems" "https://nix-community.cachix.org"];
        extra-trusted-public-keys = [
          "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
