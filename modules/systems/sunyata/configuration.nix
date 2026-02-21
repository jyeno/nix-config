{inputs, ...}: {
  flake-file.inputs = {
    # include nix-cachyos-kernel only to this machine
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  flake.modules.nixos.sunyata = {
    pkgs,
    config,
    modulesPath,
    ...
  }: {
    imports = with inputs.self.modules.nixos;
      [
        system-desktop
        virtualisation
        impermanence
        secrets
        iwd
        stylix-jyeno

        jyeno

        services-podman
        services-glance
        services-wivrn

        desktop-amd
        desktop-chromium
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
    nixpkgs.overlays = [inputs.nix-cachyos-kernel.overlays.pinned];

    boot = {
      initrd = {
        availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
        kernelModules = ["dm-snapshot" "amdgpu"];
      };
      kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto;
      kernelModules = ["kvm-amd" "amdgpu" "ntsync"];
      kernelParams = ["quiet" "clearcpuid=umip"];
      extraModulePackages = [];
    };

    swapDevices = [];

    nixpkgs.hostPlatform = "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = true;
  };
}
