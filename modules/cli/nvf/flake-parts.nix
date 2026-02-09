{
  # Modules to help you handle persistent state on systems with ephemeral root storage
  # https://github.com/nix-community/impermanence

  flake-file.inputs.nvf = {
    url = "github:notashelf/nvf";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
