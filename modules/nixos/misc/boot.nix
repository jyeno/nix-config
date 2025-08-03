{
  config,
  lib,
  ...
}: let
  cfg = config.local.misc.boot;
in {
  options.local.misc.boot.enable = lib.mkEnableOption "Enable systemd-boot configuration";
  config = lib.mkIf cfg.enable {
    boot.loader = {
      systemd-boot = {
        enable = lib.mkDefault true;
        netbootxyz.enable = true;
        extraEntries = {
          "memtest86.conf" = ''
            title netboot_arm64
            efi /efi/netboot_arm64.efi
          '';
        };
        extraFiles = {
          "efi/netboot_arm64.efi" = ./netboot_arm64.efi;
        };
      };
      efi.canTouchEfiVariables = lib.mkDefault true;
    };
  };
}
