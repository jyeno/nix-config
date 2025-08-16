{inputs}: let
  lib = inputs.nixpkgs.lib;
  scanPaths = dir: type:
    if lib.pathExists dir
    then let
      items = builtins.readDir dir;
    in
      lib.filterAttrs (n: t: t == type) items
    else {};

  discoverModules = dir:
    if !lib.pathExists dir
    then {}
    else let
      files = scanPaths dir "regular";
      dirs = scanPaths dir "directory";
      nixFiles = lib.filterAttrs (n: _: lib.hasSuffix ".nix" n && n != "default.nix") files;
      validDirs = lib.filterAttrs (n: _: lib.pathExists (dir + "/${n}/default.nix")) dirs;
      moduleFiles =
        lib.mapAttrsToList (name: _: {
          name = lib.removeSuffix ".nix" name;
          value = dir + "/${name}";
        })
        nixFiles;
      moduleDirs =
        lib.mapAttrsToList (name: _: {
          name = name;
          value = dir + "/${name}/default.nix";
        })
        validDirs;
    in
      lib.listToAttrs (
        map (m: {
          name = m.name;
          value = import m.value;
        }) (moduleFiles ++ moduleDirs)
      );

  mapPackages = dir:
    if !lib.pathExists dir
    then {}
    else let
      files = scanPaths dir "regular";
      dirs = scanPaths dir "directory";
      packageNixFiles = lib.filterAttrs (n: _: lib.hasSuffix ".nix" n && n != "default.nix") files;
      packageDirs =
        lib.mapAttrsToList (name: _: {
          name = name;
          value = dir + "/${name}/default.nix";
        })
        dirs;
      packageFiles =
        lib.mapAttrsToList (name: _: {
          name = lib.removeSuffix ".nix" name;
          value = dir + "/${name}";
        })
        packageNixFiles;
      allPotentialPackages = packageFiles ++ packageDirs;
    in
      lib.listToAttrs allPotentialPackages;

  mapHosts = dir: let
    hostDirs = scanPaths dir "directory";
  in
    lib.mapAttrs (
      hostname: _: let
        hostDir = dir + "/${hostname}";
        defaultNixPath = "${hostDir}/default.nix";
        configNixPath = "${builtins.toString dir}/${hostname}/configuration.nix";
      in
        if lib.pathExists defaultNixPath && lib.pathExists configNixPath
        then {
          hostAttrs = import defaultNixPath {inherit inputs hostname;};
          mainConfig = configNixPath;
        }
        else throw "Host directory ${hostDir} must contain both default.nix and configuration.nix"
    )
    hostDirs;

  forAllSystems = f:
    lib.listToAttrs (
      map (system: {
        name = system;
        value = f system;
      })
      inputs.nixpkgs.lib.systems.flakeExposed
    );
in {
  inherit
    scanPaths
    discoverModules
    mapPackages
    mapHosts
    forAllSystems
    ;
}
