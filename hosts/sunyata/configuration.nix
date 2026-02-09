{
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  system.stateVersion = "24.05";

  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
  };

  stylix = import ../../extras/desktop/stylixWest.nix {inherit pkgs;};

  local = {
    users.jyeno = {
      enable = true;
      keys = [
        (builtins.readFile ../../extras/pubkeys/id_jyeno.pub)
      ];
    };
    misc = {
      sops.enable = true;
    };
  };
}
