{
  description = "jyeno's flake config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    impermanence.url = "github:nix-community/impermanence";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gBar = {
      url = "github:scorpion-26/gBar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };
    hypr-contrib.url = "github:hyprwm/contrib";
    hyprpicker.url = "github:hyprwm/hyprpicker";

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

  outputs = {
    self,
    nixpkgs,
    home-manager,
    impermanence,
    chaotic,
    ...
  } @ inputs: let
    inherit (self) outputs;
    discoveredUsers = {
      # TODO have a ./modules/users/jyeno with the settings instead
      jyeno = {
        defaultNixPath = ./users/jyeno/default.nix;
        homeConfigPath = ./users/jyeno/home.nix;
      };
    };
    nixosModules = [
      # TODO automatize the modules discovery
      ./modules/nixos/cli
      ./modules/nixos/desktop
      ./modules/nixos/gaming
      ./modules/nixos/misc
      ./modules/nixos/service
      ./modules/nixos/tweaks
    ];
    homeModules = [
      ./modules/home-manager/cli/default.nix
      ./modules/home-manager/desktop/default.nix
      ./modules/home-manager/misc/default.nix
      ./modules/home-manager/wayland/default.nix
    ];
    usersModules = [
      ./modules/users/jyeno/default.nix
    ];
    homeFlakeModules = [
      inputs.sops-nix.homeManagerModules.sops
      inputs.nvf.homeManagerModules.default
      inputs.impermanence.nixosModules.home-manager.impermanence
      inputs.gBar.homeManagerModules.x86_64-linux.default
    ];
    flakeModules = [
      chaotic.nixosModules.default
      impermanence.nixosModules.impermanence
      inputs.home-manager.nixosModules.default
      inputs.disko.nixosModules.default
      inputs.sops-nix.nixosModules.sops
    ];
    homeModule = {
      home-manager.sharedModules = homeModules ++ homeFlakeModules;
      home-manager.extraSpecialArgs = {inherit inputs outputs;};
      home-manager.useGlobalPkgs = true;
    };
  in {
    nixosConfigurations = {
      # TODO optimize, mapping the hosts based on the contents of hosts/ dir
      marga = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules =
          flakeModules
          ++ [homeModule]
          ++ nixosModules
          ++ usersModules
          ++ [./hosts/marga/default.nix];
      };
      sunyata = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules =
          flakeModules
          ++ [homeModule]
          ++ nixosModules
          ++ usersModules
          ++ [./hosts/sunyata/default.nix];
      };
    };
  };
}
