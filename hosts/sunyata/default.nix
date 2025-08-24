{inputs, ...}: let
  system = "x86_64-linux";
  modules = [
    inputs.chaotic.nixosModules.default
    inputs.impermanence.nixosModules.impermanence
    inputs.disko.nixosModules.default
    inputs.sops-nix.nixosModules.sops
    inputs.stylix.nixosModules.stylix
  ];
  specialArgs = {
    homeSpecificModules = [
      inputs.sops-nix.homeManagerModules.sops
      inputs.nvf.homeManagerModules.default
      inputs.impermanence.nixosModules.home-manager.impermanence
      # inputs.gBar.homeManagerModules.x86_64-linux.default
      inputs.plasma-manager.homeManagerModules.plasma-manager
    ];
  };
in {
  inherit system modules specialArgs;
  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
}
