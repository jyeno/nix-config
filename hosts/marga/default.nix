{inputs, ...}: let
  system = "x86_64-linux";
  modules = [
    inputs.impermanence.nixosModules.impermanence
    inputs.disko.nixosModules.default
    inputs.sops-nix.nixosModules.sops
    inputs.stylix.nixosModules.stylix
  ];
  homeModules = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.nvf.homeManagerModules.default
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.plasma-manager.homeModules.plasma-manager
  ];
in {
  inherit system modules homeModules;
  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
}
