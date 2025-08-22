{inputs, ...}: {
  enable = true;
  autoEnable = true;
  image = ../wallpapers/dragon.jpg;
  # polarity = "dark";
  base16Scheme = "${inputs.nixpkgs.legacyPackages.x86_64-linux.base16-schemes}/share/themes/da-one-sea.yaml";
  fonts = {
    monospace = {
      package = inputs.nixpkgs.legacyPackages.x86_64-linux.nerd-fonts.jetbrains-mono;
      name = "JetBrains Mono Nerd Font";
    };
    # sizes = {
    #   terminal = 15;
    #   desktop = 14;
    #   applications = 14;
    # };
  };
  targets = {
    nvf.enable = true;
    qt = {
      enable = true;
      # platform = "qtct";
    };
  };
}
