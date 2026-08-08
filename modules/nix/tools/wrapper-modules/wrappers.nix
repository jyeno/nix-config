{ inputs, ... }:
{
  flake.modules.nixos.wrappers = {
    imports = [
      inputs.wrappers.flakeModules.wrappers
    ];
  };
}
