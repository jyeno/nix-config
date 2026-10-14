{ inputs, ... }:
{
  flake.modules.nixos.anatta =
    {
      lib,
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
          services-bluetooth
          services-tailscale

          zram
        ]
        ++ [
          (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
        ];

      # GPU / framebuffer

      # Bootloader (Pi firmware loads U-Boot, which reads the extlinux config
      # populated by sd-image-aarch64)
      boot = {
        initrd.availableKernelModules = [
          "xhci_pci"
          "usbhid"
          "usb_storage"
        ];
        kernelModules = [ "vc4" ];
        # system-cli enables systemd-boot (EFI); the Pi is not EFI, boot via extlinux instead
        loader = {
          systemd-boot.enable = lib.mkForce false;
          efi.canTouchEfiVariables = lib.mkForce false;
          generic-extlinux-compatible.enable = true;
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
          networks."SSID" = {
            psk = "rawPasswordHere";
          };
        };

        usePredictableInterfaceNames = false;
      };

      # Timezone
      time.timeZone = "America/Bahia";

      # Locale
      i18n.defaultLocale = "en_US.UTF-8";

      # Allow sudo for wheel
      security.sudo.wheelNeedsPassword = false;
      # Reduce size
      documentation.enable = false;

      nixpkgs.hostPlatform = "aarch64-linux";
      sdImage.compressImage = false;
    };
}
