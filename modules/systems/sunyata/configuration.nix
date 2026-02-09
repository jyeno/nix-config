{inputs, ...}: {
  flake-file.inputs = {
    # include nix-cachyos-kernel only to this machine
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };
  flake.modules.nixos.sunyata = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      system-desktop
      virtualisation
      impermanence
      secrets
      iwd

      jyeno

      services-podman
      services-glance
      services-wivrn

      desktop-amd
      desktop-chromium
      desktop-niri
      desktop-hyprland
      desktop-plasma

      gaming-general
      gaming-steam
      gaming-gamescope
      gaming-lact
    ];
    fileSystems = {
      "/data" = {
        device = "/dev/mapper/Bunk-data";
        fsType = "ext4";
        options = ["noatime" "rw" "noexec"];
      };

      "/data/games" = {
        device = "/dev/mapper/Bunk-games";
        fsType = "ext4";
        options = ["noatime" "rw"];
      };

      "/persist".neededForBoot = true;
      "/persist/home".neededForBoot = true;
    };
    networking = {
      hostName = "sunyata";
      useDHCP = false;
    };
    nixpkgs.overlays = [inputs.nix-cachyos-kernel.overlays.pinned];
    boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto;

    nixpkgs.hostPlatform = "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = true;
  };
}
