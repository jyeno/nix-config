{
  description = "jyeno's flake config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    impermanence.url = "github:nix-community/impermanence";
    nvf.url = "github:notashelf/nvf";
    # nvf.url = "github:notashelf/nvf/v0.8";
    plasma-manager.url = "github:nix-community/plasma-manager/trunk";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # my secrets repo1
    nix-secrets = {
      url = "git+ssh://git@github.com/jyeno/secrets-me?shallow=1&ref=master";
      flake = false;
    };
  };

  outputs = inputs: let
    inherit (inputs.nixpkgs) lib legacyPackages;
    localLib = import ./lib {inherit inputs;};
    discoveredHosts = localLib.mapHosts ./hosts;
    discoveredNixosModules = with localLib; (discoverModules ./modules/nixos) // (discoverModules ./modules/common);
    discoveredHomeModules = localLib.discoverModules ./modules/hm;
    discoveredPackages = localLib.mapPackages ./pkgs;
  in {
    lib = localLib;
    nixosModules = discoveredNixosModules;
    homeModules = discoveredHomeModules;
    packages = localLib.forAllSystems (
      system: let
        pkgs = legacyPackages.${system};
        mapPkgs = builtins.mapAttrs (name: path: pkgs.callPackage path {inherit system;});
      in
        mapPkgs discoveredPackages
    );
    nixosConfigurations =
      localLib.genHosts {
        specialArgs = {inherit inputs localLib;};
        inherit discoveredNixosModules discoveredHomeModules;
      }
      discoveredHosts;
  };
}
