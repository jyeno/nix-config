{
  flake.modules.nixos.systemd-boot =
    { pkgs, ... }:
    {
      boot.loader = {
        systemd-boot = {
          enable = true;
          netbootxyz.enable = true;
          extraEntries = {
            "memtest86.conf" = ''
              title netboot_arm64
              efi /efi/netboot_arm64test.efi
            '';
          };
          extraFiles = {
            # TODO check if needed
            "efi/netboot_arm64test.efi" = ./netboot_arm64.efi;
          };
        };
        efi.canTouchEfiVariables = true;
      };
    };
}
