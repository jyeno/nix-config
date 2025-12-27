{inputs}: let
  lib = inputs.nixpkgs.lib;
  scanPaths = dir: type:
    if !lib.pathExists dir
    then {}
    else
      builtins.readDir dir
      |> lib.filterAttrs (n: t: t == type);

  discoverModules = dir:
    if !lib.pathExists dir
    then {}
    else
      builtins.readDir dir
      |> lib.filterAttrs (n: t: (lib.hasSuffix ".nix" n && n != "default.nix") || t == "directory")
      |> lib.mapAttrs (n: _: import "${builtins.toString dir}/${n}")
      |> lib.filterAttrs (n: module: let
        dummyModule = module {
          pkgs = {};
          config = {};
          localLib = {};
          inherit lib inputs;
        };
        inherit (builtins) hasAttr head tail;
        countAttrs = attrs: m:
          if (attrs == [])
          then 0
          else if (hasAttr (head attrs) m)
          then 1 + countAttrs (tail attrs) m
          else 0 + countAttrs (tail attrs) m;

        # TODO be stricter with config attr, only allow if it contains only _type == "if"
        isModuleValid = m: builtins.length (builtins.attrNames m) == countAttrs ["options" "config" "imports"] m;
      in
        lib.asserts.assertMsg (isModuleValid dummyModule) "invalid ${builtins.toString dir}/${n} module");

  mapPackages = dir:
    if !lib.pathExists dir
    then {}
    else
      builtins.readDir dir
      |> lib.filterAttrs (n: t: (lib.hasSuffix ".nix" n && n != "default.nix") || t == "directory")
      |> lib.mapAttrsToList (name: _: {
        name = lib.removeSuffix ".nix" name;
        value = dir + "/${name}";
      })
      |> lib.listToAttrs;

  mapHosts = dir:
    scanPaths dir "directory"
    |> lib.mapAttrs (
      hostname: _: let
        hostDir = "${builtins.toString dir}/${hostname}";
        defaultNixPath = "${hostDir}/default.nix";
        configNixPath = "${hostDir}/configuration.nix";
      in
        if lib.pathExists defaultNixPath && lib.pathExists configNixPath
        then {
          hostAttrs = import hostDir {inherit inputs hostname;};
          mainConfig = configNixPath;
        }
        else throw "Host directory ${hostDir} must contain both default.nix and configuration.nix"
    );

  forAllSystems = f:
    map (system: {
      name = system;
      value = f system;
    })
    inputs.nixpkgs.lib.systems.flakeExposed
    |> lib.listToAttrs;

  genHosts = args: hosts:
    builtins.mapAttrs (
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
            ++ lib.optionals args.genUsers [
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  # TODO move to a better place
                  extraSpecialArgs = specialArgs;
                  sharedModules = homeSpecificModules ++ (builtins.attrValues args.discoveredHomeModules);
                };
                local.generateUsers = true;
              }
            ];
        }
    )
    hosts;
in {
  inherit
    scanPaths
    discoverModules
    mapPackages
    mapHosts
    forAllSystems
    genHosts
    ;
}
