{inputs, ...}: let
  system = "aarch64-linux";
  modules = [
    inputs.chaotic.nixosModules.default
    inputs.impermanence.nixosModules.impermanence
    inputs.disko.nixosModules.default
    inputs.sops-nix.nixosModules.sops
    inputs.lix.nixosModules.default
  ];
in {
  inherit system modules;
}
