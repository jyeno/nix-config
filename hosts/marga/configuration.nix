{
  inputs,
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  system.stateVersion = "24.05";

  stylix = import ../../extras/desktop/stylixWest.nix {inherit inputs;};

  local = {
    users.jyeno = {
      enable = true;
      home.config = import ../../extras/desktop/jyenohome.nix {inherit pkgs;};
      keys = [
        (builtins.readFile ../../extras/pubkeys/id_jyeno.pub)
      ];
    };
    cli = {
      enable = true;
      mtr = true;
      gnuAgent = true;
    };
    desktop = {
      enable = true;
      enablePams = true;
      graphics = {
        enable = true;
        # xkb = {};
      };
      nvidia.enable = true;
      plasma.enable = true;
    };
    gaming = {
      enable = true;
      settings = {
        vkbasalt.enable = false;
        ntsync.enable = true;
        mangohud.enable = true;
      };
      gamemode.enableNotifications = true;
    };
    misc = {
      networking = {
        hostName = hostname;
        firewall.enable = true;
        nameservers = ["127.0.0.1" "1.1.1.1"];
      };
      boot.enable = true;
      locale.enable = true;
      persistent.enable = true;
      sops.enable = true;
      zram.enable = true;
    };
    service = {
      bluetooth.enable = true;
      home-dns.enable = true;
      glance.enable = true;
      iwd.enable = true;
      openssh.enable = true;
      pipewire.enable = true;
      tlp.enable = true;
    };
    tweaks = {
      chromium-policies.enable = true;
      fonts.enable = true;
      io-schedulers.enable = true;
      nix.enable = true; # TODO change name
    };
  };
}
