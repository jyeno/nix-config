{inputs, ...}: {
  flake.modules = {
    nixos.secrets.imports = [
      inputs.sops-nix.nixosModules.sops
      # TODO agenix
    ];
    homeManager.secrets.imports = [
      inputs.sops-nix.homeManagerModules.sops
    ];
  };
}
