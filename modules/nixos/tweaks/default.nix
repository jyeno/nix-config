{
  lib,
  localLib,
  ...
}: {
  imports = lib.attrsets.attrValues (localLib.discoverModules ./.);
}
