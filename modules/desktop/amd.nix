{
  flake.modules.nixos.desktop-amd = {pkgs, ...}: {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = pkgs.system == "x86_64-linux";
      };
      amdgpu.initrd.enable = true;
    };
  };
}
