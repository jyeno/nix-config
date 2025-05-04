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
        hdr.enable = false;
        rt.enable = true;
        vrr.enable = false;
        vkbasalt.enable = true;
        ntsync.enable = true;
        mangohud.enable = true;
      };
      gamemode.enableNotifications = true;
      gamescope = {
        outputWidth = 3440;
        outputHeight = 1440;
        nestedRefresh = 145;
        nestedUnfocusedRefresh = 30;
      };
      lact = {
        enable = true;
        overclock = true;
        config = {
          daemon = {
            log_level = "info";
            admin_groups = [
              "wheel"
              "sudo"
            ];
            disable_clocks_cleanup = false;
          };
          apply_settings_timer = 5;
          gpus = {
            "1002:73DF-1458:2331-0000:03:00.0" = {
              fan_control_enabled = false;
              # fan_control_settings = {
              #   mode = "curve";
              #   static_speed = 0.7075070821529745;
              #   temperature_key = "edge";
              #   interval_ms = 500;
              #   curve = {
              #     "40" = 0.2;
              #     "50" = 0.35;
              #     "60" = 0.5;
              #     "70" = 0.75;
              #     "80" = 1.0;
              #   };
              #   spindown_delay_ms = 5000;
              #   change_threshold = 2;
              # };
              power_cap = 174.0;
              performance_level = "auto";
            };
          };
        };
      };
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
