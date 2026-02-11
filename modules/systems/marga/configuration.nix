{inputs, ...}: {
  flake.modules.nixos.marga = {
    config,
    modulesPath,
    pkgs,
    ...
  }: {
    imports = with inputs.self.modules.nixos;
      [
        system-desktop
        impermanence
        secrets
        iwd
        stylix-jyeno

        jyeno

        services-glance
        services-tlp

        desktop-nvidia
        desktop-firefox
        desktop-qutebrowser
        desktop-plasma
      ]
      ++ [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

    boot = {
      initrd = {
        availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
        kernelModules = ["dm-snapshot"];
      };
      kernelPackages = pkgs.linuxPackages_latest;
      kernelModules = ["kvm-amd"];
      kernelParams = ["nvidia-drm.fbdev=1"];
      extraModulePackages = [];
    };

    fileSystems = {
      "/data" = {
        device = "/dev/sda4";
        fsType = "ext4";
        options = ["noatime" "rw" "noexec"];
      };

      "${config.systemConstants.persistDir}".neededForBoot = true;
      "${config.systemConstants.persistDir}/home".neededForBoot = true;
    };
    networking = {
      hostName = "marga";
      useDHCP = false;
    };
    nixpkgs.hostPlatform = "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = true;
  };
}
