{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking = {
    hostName = "marga";
  };

  system.stateVersion = "24.05";

  local = {
    users.jyeno.enable = true;
    cli = {
      enable = true;
      mtr = true;
      gnuAgent = true;
    };
    desktop = {
      enable = true;
      enablePams = true;
      stylix = {
        enable = true;
        autoEnable = true;
        image = ../../extras/wallpapers/dragon.jpg;
        # polarity = "dark";
        base16Scheme = "${inputs.nixpkgs.legacyPackages.x86_64-linux.base16-schemes}/share/themes/catppuccin-frappe.yaml";
        fonts = {
          monospace = {
            package = inputs.nixpkgs.legacyPackages.x86_64-linux.nerd-fonts.jetbrains-mono;
            name = "JetBrains Mono Nerd Font";
          };
          # sizes = {
          #   terminal = 15;
          #   desktop = 14;
          #   applications = 14;
          # };
        };
        targets = {
          nvf.enable = true;
          qt = {
            enable = true;
            # platform = "qtct";
          };
        };
      };
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
