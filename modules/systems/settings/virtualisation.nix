{
  flake.modules.nixos.virtualisation =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        virt-manager
        virt-viewer
        spice
        spice-gtk
        spice-protocol
        virtio-win
        win-spice
        adwaita-icon-theme
      ];

      virtualisation = {
        libvirtd = {
          enable = true;
          qemu.swtpm.enable = true;
        };
        spiceUSBRedirection.enable = true;
      };
      services.spice-vdagentd.enable = true;
    };
}
