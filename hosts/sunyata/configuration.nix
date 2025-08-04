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

  networking = {
    hostName = hostname;
  };

  system.stateVersion = "24.05";

  chaotic.mesa-git.enable = false;

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
      stylix = import ../../extras/desktop/stylixWest.nix {inherit inputs;};
      graphics = {
        enable = true;
        # xkb = {};
      };
      hyprland.enable = false;
      river.enable = false;
      nvidia.enable = false;
      plasma.enable = true;
      wireshark.enable = false;
    };
    gaming = {
      enable = true;
      settings = {
        hdr.enable = true;
        rt.enable = true;
        vrr.enable = true;
        vkbasalt.enable = true;
        ntsync.enable = true;
        wow64.enable = true;
        mangohud.enable = true;
        wayland.enable = true;
      };
      gamemode.enableNotifications = true;
      gamescope = {
        enable = false;
        outputWidth = 3440;
        outputHeight = 1440;
        nestedRefresh = 165;
        nestedUnfocusedRefresh = 30;
        hdrItmSdrNits = 101;
        hdrItmTargetNits = 400;
        hdrSdrContentNits = 250;
        sdrGamutWideness = 0.5;
      };
      lact = import ../../extras/desktop/lactcfg.nix;
    };
    misc = {
      firewall = {
        enable = true;
        # nameservers = [];
      };
      boot.enable = true;
      locale.enable = true;
      persistent.enable = true;
      sops.enable = true;
      virtualisation.enable = true;
      zram.enable = true;
    };
    service = {
      bluetooth.enable = true;
      docker.enable = false;
      home-dns.enable = true;
      iwd.enable = true;
      jenkins.enable = false;
      mysql.enable = false;
      openssh.enable = true;
      pipewire.enable = true;
      podman.enable = true;
      postgres.enable = false;
      tlp.enable = false;
    };
    tweaks = {
      chromium-policies.enable = true;
      fonts.enable = true;
      io-schedulers.enable = true;
      nix.enable = true; # TODO change name
    };
  };
}
