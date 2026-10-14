{
  # Manage KDE Plasma with Home Manager
  # https://github.com/nix-community/plasma-manager

  flake-file.inputs.plasma-manager = {
    url = "github:nix-community/plasma-manager/trunk";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
