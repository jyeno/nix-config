{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.desktop.nvidia;
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  options.local.desktop.nvidia.enable = lib.mkEnableOption "Enable nvidia configuration";
  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = lib.mkDefault ["nvidia"];

    environment.systemPackages = with pkgs; [
      nvtopPackages.nvidia
      nvidia-offload
    ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.latest;

      prime = {
        offload = {
          enable = true;
        };
        amdgpuBusId = lib.mkDefault "PCI:5:0:0";
        nvidiaBusId = lib.mkDefault "PCI:1:0:0";
      };
    };
  };
}
