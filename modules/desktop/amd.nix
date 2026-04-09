{
  flake.modules.nixos.desktop-amd =
    { pkgs, ... }:
    {
      hardware = {
        graphics = {
          enable = true;
          enable32Bit = pkgs.system == "x86_64-linux";
          extraPackages = with pkgs; [
            vulkan-loader
            vulkan-validation-layers
          ];
        };
        amdgpu.initrd.enable = true;
      };
    };
}
