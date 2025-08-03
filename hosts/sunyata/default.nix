{inputs, ...}: let
  system = "x86_64-linux";
  modules = [
    inputs.chaotic.nixosModules.default
    inputs.impermanence.nixosModules.impermanence
    inputs.disko.nixosModules.default
    inputs.sops-nix.nixosModules.sops
    inputs.lix.nixosModules.default
    inputs.stylix.nixosModules.stylix
  ];
in {
  inherit system modules;
  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
}
