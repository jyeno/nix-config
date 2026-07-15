{
  # Module to configure neovim on nixos
  # https://github.com/notashelf/nvf

  flake-file.inputs.nvf = {
    url = "github:notashelf/nvf";
    # inputs.nixpkgs.follows = "nixpkgs";
  };
}
