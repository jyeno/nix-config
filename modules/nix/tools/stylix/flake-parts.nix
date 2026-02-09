{
  # Theming framework for NixOS, Home Manager, nix-darwin, and Nix-on-Droid
  # https://github.com/nix-community/stylix

  flake-file.inputs.stylix = {
    url = "github:nix-community/stylix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
