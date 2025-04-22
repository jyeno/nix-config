{localLib, ...}: let
  discoveredNixosModules = builtins.trace "Discovered modules:" (localLib.discoverModules ./modules/nixos);
in {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking = {
    hostName = "marga";
  };

  boot.loader.grub.enable = false;

  system.stateVersion = "24.05";
}
