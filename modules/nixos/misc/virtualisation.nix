{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.misc.virtualisation;
in {
  options.local.misc.virtualisation.enable = lib.mkEnableOption "Enable virtualisation configuration";
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      win-virtio
      win-spice
      adwaita-icon-theme
    ];

    virtualisation = {
      libvirtd = {
        enable = lib.mkDefault true;
        qemu = {
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [pkgs.OVMFFull.fd];
        };
      };
      spiceUSBRedirection.enable = true;
    };
    services.spice-vdagentd.enable = true;
  };
}
