{
  # Library for using modules to wrap packages with configuration directly, and a collection of pre-built wrapper modules!
  # https://github.com/BirdeeHub/nix-wrapper-modules

  flake-file.inputs.wrappers = {
    url = "github:BirdeeHub/nix-wrapper-modules";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
