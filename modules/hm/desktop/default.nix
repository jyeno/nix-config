{
  config,
  lib,
  # localLib,
  ...
}: {
  # imports = lib.attrsets.attrValues (localLib.discoverModules ./.);
  imports = [
    ./chromium.nix
    ./cliphist.nix
    ./firefox.nix
    ./ghostty.nix
    ./zathura.nix
    ./plasma.nix
    ./qutebrowser.nix
    ./hyprland.nix
    ./riverwm.nix
    ./wlr
  ];
  options.local.home.desktop.enable = lib.mkEnableOption "Enable desktop settingss";
}
