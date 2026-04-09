{ inputs, ... }:
{
  flake.modules.nixos.anatta =
    {
      modulesPath,
      pkgs,
      ...
    }:
    {
      imports =
        with inputs.self.modules.nixos;
        [
          system-cli

          jyeno

          services-podman
          services-tailscale
          services-minidlna
        ]
        ++ [
          (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
        ];

      # GPU / framebuffer

      # Bootloader (Pi firmware handles boot)
      boot = {
        initrd.availableKernelModules = [
          "xhci_pci"
          "usbhid"
          "usb_storage"
        ];
        kernelModules = [ "vc4" ];
        loader = {
          grub.enable = false;
          raspberryPi = {
            enable = true;
            version = 3;
            # firmwareConfig = ''
            #   core_freq=250
            # '';
          };
        };

        # Kernel
        kernelPackages = pkgs.linuxPackages_latest;
      };

      # Filesystem (adjust if needed)
      fileSystems."/" = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
      };

      # Enable firmware (important for WiFi, etc.)
      hardware.enableRedistributableFirmware = true;

      # Networking
      networking = {
        hostName = "anatta";
        useDHCP = true;
        # useDHCP = false;
        interfaces.wlan0.useDHCP = true;
        wireless = {
          enable = true;
          # TODO move to secrets secretsFile = config.age.secrets.wifi-password.path;
          networks."home" = {
            ssid = "my-network";
            pskRaw = "ext:psk_home";
          };
        };

        usePredictableInterfaceNames = false;
      };

      # Timezone
      time.timeZone = "America/Bahia";

      # Locale
      i18n.defaultLocale = "en_US.UTF-8";

      # TODO Create a user jlatoo

      # Allow sudo for wheel
      security.sudo.wheelNeedsPassword = false;
      # Reduce size
      documentation.enable = false;

      nixpkgs.hostPlatform = "aarch64-linux";
      sdImage.compressImage = false;
    };
}
