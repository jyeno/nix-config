{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking = {
    hostName = "marga";
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
      nvidia.enable = true;
    };
    gaming = {
      enable = true;
      settings = {
        vkbasalt.enable = true;
        ntsync.enable = true;
        mangohud.enable = true;
      };
      gamemode.enableNotifications = true;
      gamescope.enable = false;
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
      zram.enable = true;
    };
    service = {
      bluetooth.enable = true;
      home-dns.enable = true;
      iwd.enable = true;
      openssh.enable = true;
      pipewire.enable = true;
      tlp.enable = true;
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
