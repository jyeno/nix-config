{
  inputs,
  lib,
  ...
}: {
  flake = {
    nixosConfigurations = inputs.self.lib.mkNixos "aarch64-linux" "nirvana";
    homeConfigurations = lib.mkMerge [
      (builtins.map (username: inputs.self.lib.mkHomeManager "aarch64-linux" "vps-${username}")
        ["cassio" "igorcafe" "oliver" "leonardohn" "jyeno"]) # TODO get list
    ];
  };
}
