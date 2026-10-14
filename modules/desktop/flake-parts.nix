{
  flake-file.inputs = {
    niri-spicy = {
      url = "github:losnoco/niri?ref=spicy-main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    smithay-spicy = {
      url = "github:losnoco/smithay?ref=spicy-master";
      flake = false;
    };
  };
}
