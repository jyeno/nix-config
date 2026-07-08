{ inputs, ... }: {
  flake.modules.nixos.nyx = {
    nix.settings = {
      substituters = [ "https://nyx-cache.chaotic.cx" ];
      trusted-public-keys = [
        "nyx-cache.chaotic.cx:dJxTrgMC3V3cFfyIiBQDQorG6k1LsqurH/srpMSq7qk="
      ];
    };

    imports = [ inputs.chaotic.nixosModules.default ];
  };
}
