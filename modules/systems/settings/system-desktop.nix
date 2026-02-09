{inputs, ...}: {
  # expansion of cli system for desktop use

  flake.modules.nixos.system-desktop = {
    imports = with inputs.self.modules.nixos; [
      system-cli
      stylix
      zram

      services-home-dns
      services-pipewire
      services-bluetooth

      desktop-general
      desktop-pam
    ];
  };

  flake.modules.homeManager.system-desktop = {pkgs, ...}: {
    imports = with inputs.self.modules.homeManager; [
      system-cli

      cli-pass
      cli-players
      cli-mpd

      desktop-general
      desktop-easyeffects
    ];
    home.packages = with pkgs; [
      lm_sensors
      lsof
      usbutils
      pciutils
    ];
  };
}
