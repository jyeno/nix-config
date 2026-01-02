{inputs, ...}: let
  system = "aarch64-linux";
  modules = [
    inputs.impermanence.nixosModules.impermanence
    inputs.sops-nix.nixosModules.sops
  ];
  homeModules = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.nvf.homeManagerModules.default
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];
in {
  inherit system modules homeModules;
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        x86 = import inputs.nixpkgs {
          system = "x86_64-linux";
          #modules = [inputs.chaotic.nixosModules.default];
          config.allowUnfree = true;
        };
      })
    ];
  };
}
