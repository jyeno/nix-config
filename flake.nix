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
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager.url = "github:nix-community/plasma-manager";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # gBar = {
    #   url = "github:scorpion-26/gBar";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # my secrets repo1
    nix-secrets = {
      url = "git+ssh://git@github.com/jyeno/secrets-me?shallow=1&ref=master";
      flake = false;
    };
  };

  outputs = inputs: let
    #     inherit (self) outputs;
    inherit (builtins) attrValues mapAttrs;
    inherit (inputs.nixpkgs) lib legacyPackages;
    localLib = import ./lib {inherit inputs;};
    discoveredHosts = localLib.mapHosts ./hosts;
    # discoveredHosts = let hostsDir = builtins.path {path = ./hosts; name = "hosts";}; in localLib.mapHosts hostsDir;
    discoveredNixosModules = localLib.discoverModules ./modules/nixos;
    discoveredHomeModules = localLib.discoverModules ./modules/hm;
    discoveredPackages = localLib.mapPackages ./pkgs;
    userOptionsModule = {
      config,
      pkgs,
      ...
    }: {
      options.local.users = lib.mkOption {
        default = {};
        description = "user settings";
        type = with lib.types; attrsOf (submodule {
            options = {
              enable = lib.mkEnableOption "Enable user configuration";
              homeConfig = lib.mkOption {
                type = lib.types.attrs;
                default = {};
                description = "User home configuration";
              };
              keys = lib.mkOption {
                type = with lib.types; listOf str;
                default = [];
                description = "ssh public keys";
              };
              shell = lib.mkOption {
                type = lib.types.package;
                default = pkgs.fish;
                description = "user shell";
              };
              extraGroups = {
                type = with lib.types; listOf str;
                default = let
                  #TODO maybe wrong to let it here
                  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
                in
                  [
                    "wheel"
                    "video"
                    "audio"
                    "input"
                  ]
                ++ ifTheyExist [
                  "network"
                  "seat"
                  "wireshark"
                  "i2c"
                  "mysql"
                  "docker"
                  "podman"
                  "git"
                  "libvirtd"
                  "deluge"
                  "gamemode"
                ];
                description = "List of user groups";
              };
            };
          });
        };
      };
    userModule = {
      config,
      pkgs,
      ...
    } @ moduleArgs: {
      users.users =
        mapAttrs
        (
          username: userConfig:
            lib.optionals userConfig.enable
            {
              inherit username;
              isNormalUser = lib.mkDefault true;
              description = "user ${username}";
              shell = userConfig.shell;
              ignoreShellProgramCheck = lib.mkDefault true;
              extraGroups = userConfig.extraGroups;
              openssh.authorizedKeys.keys = userConfig.keys;
            }
        )
        config.local.users;
      home-manager = {
        sharedModules =
          attrValues discoveredHomeModules
          ++ [
            inputs.sops-nix.homeManagerModules.sops
            inputs.nvf.homeManagerModules.default
            inputs.impermanence.nixosModules.home-manager.impermanence
            # inputs.gBar.homeManagerModules.x86_64-linux.default
            inputs.plasma-manager.homeManagerModules.plasma-manager
          ];
        # extraSpecialArgs = {inherit inputs outputs;};
        useGlobalPkgs = true;
        users =
          mapAttrs (
            username: userConfig:
              lib.optionals userConfig.enable
              (let
                # args = moduleArgs // {
                #   inherit username;
                # };
                baseHomeConfig = {
                  home.username = "${username}";
                  home.homeDirectory = "/home/${username}";

                  programs.home-manager.enable = true;
                  home.packages = with pkgs; [
                    neovim
                    tmux
                    git
                  ];

                  systemd.user.startServices = "sd-switch";
                  home.stateVersion = "25.05";
                };
              in
                lib.recursiveUpdate baseHomeConfig userConfig.homeConfig)
          )
          config.local.users;
      };
    };
  in {
    lib = localLib;
    nixosModules =
      discoveredNixosModules
      // {
        generateUsers = userModule;
      };
    homeManagerModules = discoveredHomeModules;
    packages = localLib.forAllSystems (
      system: let
        pkgs = legacyPackages.${system};
        mapPkgs = mapAttrs (name: path: pkgs.callPackage path {inherit system;});
      in
        mapPkgs discoveredPackages
    );
    nixosConfigurations =
      mapAttrs (
        hostname: hostData: let
          hostAttrs = hostData.hostAttrs;
          system = hostAttrs.system;
          hostSpecificSpecialArgs = hostAttrs.specialArgs or {};
          hostSpecificModules = hostAttrs.modules or [];
          specialArgs =
            {
              inherit
                hostname
                inputs
                localLib
                system
                ;
            }
            // hostSpecificSpecialArgs;
        in
          lib.nixosSystem {
            inherit system specialArgs;
            modules =
              hostSpecificModules
              ++ attrValues discoveredNixosModules
              ++ [userOptionsModule]
              ++ [hostData.mainConfig]
              ++ [
                inputs.home-manager.nixosModules.home-manager
                userModule
              ];
          }
      )
      discoveredHosts;
  };
}
