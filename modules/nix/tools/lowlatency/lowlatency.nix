{ inputs, ... }: {
  flake.modules.nixos.lowlatency = { pkgs, ... }: {
    hardware.graphics.extraPackages =
      let
        inherit (pkgs.stdenv.hostPlatform) system;
      in
      [
        inputs.low-latency-layer.packages.${system}.low-latency-layer
      ];
  };
}
