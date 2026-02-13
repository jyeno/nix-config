{inputs, ...}: let
  home-manager-config = {
    lib,
    config,
    ...
  }: {
    home-manager = {
      verbose = true;
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "backup";
      backupCommand = "rm";
      overwriteBackup = true;
      extraSpecialArgs = {
        graphicsEnabled = config.hardware.graphics.enable;
        niriEnabled = config.programs.niri.enable;
        hyprlandEnabled = config.programs.hyprland.enable;
        plasmaEnabled = config.services.desktopManager.plasma6.enable;
      };
    };
  };
in {
  flake.modules.nixos.home-manager = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      home-manager-config
    ];
  };
}
