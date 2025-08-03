{inputs, ...}: let
  system = "aarch64-linux";
  modules = [
    inputs.chaotic.nixosModules.default
    # inputs.impermanence.nixosModules.impermanence
    # inputs.disko.nixosModules.default
    # inputs.sops-nix.nixosModules.sops
    # inputs.lix.nixosModules.default
  ];
in {
  inherit system modules;
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
