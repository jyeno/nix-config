{inputs, ...}: {
  flake.modules.nixos.nirvana = {
    lib,
    pkgs,
    modulesPath,
    ...
  }: {
    imports = with inputs.self.modules.nixos;
      [
        system-cli

        services-podman

        gaming-xonotic-server
      ]
      ++ [
        (modulesPath + "/profiles/qemu-guest.nix")
      ];
    boot = {
      initrd = {
        availableKernelModules = ["xhci_pci" "usbhid" "virtio_pci" "virtio_scsi"];
        kernelModules = [];
      };
      kernelPackages = pkgs.linuxPackages_latest;
      kernelParams = ["net.ifnames=0"];
      extraModulePackages = [];
      tmp = {
        useTmpfs = true;
        tmpfsSize = "8G";
      };
    };

    time.timezone = "America/Sao_Paulo";
    documentation.man.enable = false;
    security.sudo.wheelNeedsPassword = false;

    # fileSystems."/".neededForBoot = true;
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/2ba400bb-3ec6-43a3-9661-0f2e5d109368";
        fsType = "xfs";
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/A77B-82BC";
        fsType = "vfat";
        options = [
          "defaults"
          "nodev"
          "noexec"
          "nosuid"
          "dmask=0077"
          "fmask=0077"
        ];
      };
    };

    nixpkgs.overlays = [
      (final: prev: {
        x86 = import inputs.nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
      })
    ];

    nixpkgs.hostPlatform = "aarch64-linux";
  };
}
