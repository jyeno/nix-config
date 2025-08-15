{
  lib,
  localLib,
  ...
}: {
  # imports = lib.attrsets.attrValues (localLib.discoverModules ./.);
  imports = [
    ./persistent.nix
    ./sops.nix
    ./sound.nix
  ];
}
