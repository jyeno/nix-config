{
  description = "basic Nix-on-Droid flake system configuration";
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf?ref=v0.8";

    plasma-manager.url = "github:nix-community/plasma-manager";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixdroid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };
  outputs = inputs: let
    inherit (builtins) attrValues mapAttrs;
    inherit (inputs.nixpkgs) lib legacyPackages;
    localLib = import ../../lib {inherit inputs;};
    discoveredHomeModules = localLib.discoverModules ../../modules/hm;

    specialArgs = {
      homeSpecificModules = [
        inputs.sops-nix.homeManagerModules.sops
        inputs.nvf.homeManagerModules.default
        inputs.impermanence.nixosModules.home-manager.impermanence
        inputs.plasma-manager.homeManagerModules.plasma-manager
      ];
    };
  in {
    nixOnDroidConfigurations.default = inputs.nixdroid.lib.nixOnDroidConfiguration {
      pkgs = import inputs.nixpkgs {
        system = "aarch64-linux";
        config.allowUnfree = true;
      };
      modules = [
        # inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            backupFileExtension = "backup";
            sharedModules = (specialArgs.homeSpecificModules or []) ++ (attrValues discoveredHomeModules);
          };
        }
        ./configuration.nix
      ];
    };
  };
}
