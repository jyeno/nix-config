{
  # default settings needed for all nixosConfigurations
  flake-file.inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  flake.modules.nixos.system-minimal = {
    nixpkgs.config.allowUnfree = true;
    system.stateVersion = "25.05";

    users.mutableUsers = false;

    nix = {
      optimise.automatic = true;
      settings = {
        warn-dirty = true;
        auto-optimise-store = false;
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];
        download-buffer-size = 1024 * 1024 * 1024;
        substituters = [
          "https://cache.nixos.org?priority=10"
          "https://install.determinate.systems"
          "https://nix-community.cachix.org"
          "https://attic.xuyh0120.win/lantian"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM"
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };
  };

  flake.modules.homeManager.system-minimal =
    { config, ... }:
    {
      home.homeDirectory = "/home/${config.home.username}";
      home.stateVersion = "25.05";
    };

  perSystem =
    {
      pkgs,
      system,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nixfmt
          pre-commit
        ];
      };
    };
}
