{ inputs, ... }:
{
  flake.modules.nixos.stylix = {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];
  };
}
