{
  # Firefox plugins as nix packages
  # https://gitlab.com/rycee/nur-expressions?dir=pkgs/firefox-addons

  flake-file.inputs.firefox-addons = {
    url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
