{
  flake.modules.nixos.desktop-nvidia =
    {
      pkgs,
      config,
      ...
    }:
    let
      nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        exec "$@"
      '';
    in
    {
      hardware = {
        graphics = {
          enable = true;
          enable32Bit = pkgs.system == "x86_64-linux";
        };
        nvidia = {
          modesetting.enable = true;
          powerManagement.enable = false;
          powerManagement.finegrained = false;
          open = false;
          nvidiaSettings = true;
          package = config.boot.kernelPackages.nvidiaPackages.latest;

          prime = {
            offload = {
              enable = true;
            };
            amdgpuBusId = "PCI:5:0:0";
            nvidiaBusId = "PCI:1:0:0";
          };
        };
      };
      services.xserver.videoDrivers = [ "nvidia" ];

      environment.systemPackages = with pkgs; [
        nvtopPackages.nvidia
        nvidia-offload
      ];
    };
}
