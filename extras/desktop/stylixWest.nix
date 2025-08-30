{
  pkgs,
  ...
}: {
  enable = true;
  autoEnable = true;
  image = ../wallpapers/dragon.jpg;
  # polarity = "dark";
  base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-sea.yaml";
  fonts = {
    monospace = {
      package = pkgs.nerd-fonts.iosevka;
      name = "Iosevka NFM";
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
      enable = true; # TODO change this back to kde6
      platform = pkgs.lib.mkForce "lxqt";
    };
  };
}
