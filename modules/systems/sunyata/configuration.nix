{ inputs, ... }:
{
  flake.modules.nixos.sunyata =
    {
      pkgs,
      config,
      modulesPath,
      ...
    }:
    {
      imports =
        with inputs.self.modules.nixos;
        [
          system-desktop
          virtualisation
          impermanence
          secrets
          iwd
          stylix-jyeno
          nyx
          lowlatency

          jyeno

          services-podman
          services-glance
          services-minidlna
          # services-wivrn

          desktop-amd
          desktop-wlr
          # desktop-chromium
          desktop-niri
          # desktop-hyprland
          # desktop-plasma

          gaming-general
          gaming-steam
          gaming-gamescope
          gaming-lact
        ]
        ++ [
          (modulesPath + "/installer/scan/not-detected.nix")
        ];

      fileSystems."${config.systemConstants.persistDir}".neededForBoot = true;
      networking = {
        hostName = "sunyata";
        useDHCP = false;
      };
      services.libinput = {
        enable = true;
        mouse.accelProfile = "flat";
      };
      services.fwupd.enable = true;

      boot = {
        initrd = {
          availableKernelModules = [
            "nvme"
            "xhci_pci"
            "ahci"
            "usb_storage"
            "usbhid"
            "sd_mod"
          ];
          kernelModules = [
            "dm-snapshot"
            "amdgpu"
          ];
          # systemd.enable = false;
        };
        kernelPackages = pkgs.linuxPackages_cachyos-lto-znver4;
        kernelModules = [
          "kvm-amd"
          "amdgpu"
          "ntsync"
        ];
        kernelParams = [
          "quiet"
          "clearcpuid=umip"
          "pcie_aspm=off"
          "amdgpu.gpu_recovery=1"
          "amdgpu.runpm=0"
        ];
        extraModulePackages = [ ];
      };

      # chaotic.hdr.enable = true;

      swapDevices = [ ];

      nixpkgs.hostPlatform = "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = true;
    };
}
