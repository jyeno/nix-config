{
  inputs,
  lib ? inputs.nixpkgs.lib,
}: let
  scanPaths = dir: type:
    lib.optionalAttrs (lib.pathExists dir)
    dir
    |> builtins.readDir
    |> lib.filterAttrs (n: t: t == type);

  discoverModules = dir:
    lib.optionalAttrs (lib.pathExists dir)
    dir
    |> builtins.readDir
    |> lib.filterAttrs (n: t: (lib.hasSuffix ".nix" n && n != "default.nix") || t == "directory")
    |> lib.mapAttrs (n: _: import "${builtins.toString dir}/${n}")
    |> validateModules dir;

  mapPackages = dir:
    if !lib.pathExists dir
    then {}
    else
      builtins.readDir dir
      |> lib.filterAttrs (n: t: (lib.hasSuffix ".nix" n && n != "default.nix") || t == "directory")
      |> lib.mapAttrs' (
        name: _:
          lib.nameValuePair (lib.removeSuffix ".nix" name) (dir + "/${name}")
      );

  mapUsers = dir:
    scanPaths dir "directory"
    |> lib.mapAttrs (
      username: _: let
        userDir = dir + "/${username}";
        defaultNixPath = "${userDir}/default.nix";
        homeConfigPath = "${userDir}/home.nix";
        isConfigValid = lib.pathExists defaultNixPath && lib.pathExists homeConfigPath;
      in
        lib.optionalAttrs (lib.asserts.assertMsg isConfigValid
          "User directory ${userDir} must contain both default.nix and home.nix")
        {
          inherit defaultNixPath homeConfigPath;
        }
    );

  mapHosts = dir:
    scanPaths dir "directory"
    |> lib.mapAttrs (
      hostname: _: let
        hostDir = "${builtins.toString dir}/${hostname}";
        defaultNixPath = "${hostDir}/default.nix";
        mainConfig = "${hostDir}/configuration.nix";
        isConfigValid = lib.pathExists defaultNixPath && lib.pathExists mainConfig;
      in
        lib.optionalAttrs (lib.asserts.assertMsg isConfigValid
          "Host directory ${hostDir} must contain both default.nix and configuration.nix")
        {
          hostAttrs = import hostDir {inherit inputs hostname;};
          inherit mainConfig;
        }
    );

  forAllSystems = f:
    inputs.nixpkgs.lib.systems.flakeExposed
    |> map (system: {
      name = system;
      value = f system;
    })
    |> lib.listToAttrs;

  genHosts = args: hosts:
    hosts
    |> builtins.mapAttrs (
      hostname: hostData: let
        hostAttrs = hostData.hostAttrs;
        system = hostAttrs.system;
        hostSpecificSpecialArgs = hostAttrs.specialArgs or {};
        hostSpecificModules = hostAttrs.modules or [];
        homeSpecificModules = hostAttrs.homeModules or [];
        pkgs = hostAttrs.pkgs or inputs.nixpkgs.legacyPackages.${system};
        specialArgs = args.specialArgs // hostSpecificSpecialArgs // {inherit hostname system;};
      in
        lib.nixosSystem {
          inherit pkgs system specialArgs;
          modules =
            hostSpecificModules
            ++ (builtins.attrValues args.discoveredNixosModules)
            ++ [hostData.mainConfig]
            ++ [
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  # TODO move to a better place
                  extraSpecialArgs = specialArgs;
                  sharedModules = homeSpecificModules ++ (builtins.attrValues args.discoveredHomeModules);
                };
                local.generateUsers = args.genUsers or false;
              }
            ];
        }
    );

  validateModules = dir: modules:
    modules
    |> lib.filterAttrs (n: module: let
      inherit (builtins) hasAttr head tail length attrNames toString;
      dummyModule = module {
        pkgs = {};
        config = {};
        localLib = {};
        inherit lib inputs;
      };
      countAttrs = attrs: m:
        if (attrs == [])
        then 0
        else if (hasAttr (head attrs) m)
        then 1 + countAttrs (tail attrs) m
        else 0 + countAttrs (tail attrs) m;

      # TODO be stricter with config attr, only allow if it contains only _type == "if"
      isModuleValid = m: (length (attrNames m) == countAttrs ["options" "config" "imports"] m);
    in
      lib.asserts.assertMsg (isModuleValid dummyModule) "invalid ${toString dir}/${n} module");
in {
  inherit
    scanPaths
    discoverModules
    mapPackages
    mapUsers
    mapHosts
    forAllSystems
    genHosts
    ;
}
