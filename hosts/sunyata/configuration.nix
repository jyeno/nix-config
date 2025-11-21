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

  services.xserver.desktopManager.gnome.enable = false;
  services.gnome.core-os-services.enable = false;
  systemd.user.services.orca.enable = false;
  services.gnome.at-spi2-core.enable = false;

  chaotic = {
    mesa-git.enable = false;
    hdr = {
      enable = true;
      specialisation.enable = false;
    };
  };

  stylix = import ../../extras/desktop/stylixWest.nix {inherit pkgs;};

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
      plasma.enable = true;
      hyprland.enable = true;
    };
    gaming = {
      enable = true;
      settings = {
        hdr.enable = true;
        rt.enable = true;
        vrr.enable = true;
        vkbasalt.enable = true;
        ntsync.enable = true;
        # wow64.enable = true;
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
      networking = {
        hostName = hostname;
        firewall.enable = true;
        nameservers = ["127.0.0.1" "1.1.1.1"];
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
      glance.enable = true;
      iwd.enable = true;
      openssh.enable = true;
      pipewire.enable = true;
      podman.enable = true;
      wivrn = {
        enable = false;
        defaultRuntime = true;
        autoStart = true;
        xrizer = false;
        json = {
          bitrate = 100000000; # Mb/s
          encoders = [
            {
              encoder = "vaapi";
              codec = "h265";
              width = 1.0;
              height = 1.0;
              offset_x = 0.0;
              offset_y = 0.0;
            }
          ];
          # application = [ pkgs.wlx-overlay-s ];
        };
      };
    };
    tweaks = {
      chromium-policies.enable = true;
      fonts.enable = true;
      io-schedulers.enable = true;
      nix.enable = true; # TODO change name
    };
  };
}
