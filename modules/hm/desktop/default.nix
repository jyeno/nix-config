{
  lib,
  localLib,
  ...
}: {
  imports = lib.attrsets.attrValues (localLib.discoverModules ./.);
  options.local.home.desktop.enable = lib.mkEnableOption "Enable desktop settingss";
}
