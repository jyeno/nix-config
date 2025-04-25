{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking = {
    # TODO put it on flake.nix
    hostName = "sunyata";
  };

  system.stateVersion = "24.05";

  local = {
    cli = {
      enable = true;
      mtr = true;
      gnuAgent = true;
    };
    desktop = {
      enablePams = true;
      graphics = {
        enable = true;
        # xkb = {};
      };
      hyprland.enable = true;
      river.enable = false;
      nvidia.enable = false;
      plasma.enable = false;
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
        mangohud.enable = true;
      };
      gamemode.enableNotifications = true;
      #gamescope = {};
      lact.enable = true;
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
      docker.enable = true;
      home-dns.enable = true;
      iwd.enable = true;
      jenkins.enable = false;
      mysql.enable = false;
      openssh.enable = true;
      pipewire.enable = true;
      podman.enable = false;
      postgres.enable = false;
      tlp.enable = false;
    };
    tweaks = {
      chromium-policies.enable = true;
      fonts.enable = true;
      io-schedulers.enable = true;
      nix = {
        enable = true; # TODO change name
        allowUnfree = true;
      };
    };
  };
}
