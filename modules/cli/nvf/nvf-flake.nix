{ inputs, ... }:
{
  flake.modules.homeManager.nvf = {
    imports = [
      inputs.nvf.homeManagerModules.default
    ];
  };
}
