{inputs, ...}: {
  flake.modules.nixos.marga = {
    imports = with inputs.self.modules.nixos; [
      systemd-desktop
      iwd
      impermanence
      secrets

      jyeno

      services-glance
      services-tlp

      desktop-nvidia
      desktop-firefox
      desktop-qutebrowser
      desktop-plasma
    ];
    fileSystems = {
      "/data" = {
        device = "/dev/sda4";
        fsType = "ext4";
        options = ["noatime" "rw" "noexec"];
      };

      "/persist".neededForBoot = true;
      "/persist/home".neededForBoot = true;
    };
    #networking.useDHCP = false;
    nixpkgs.hostPlatform = "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = true;
  };
}
