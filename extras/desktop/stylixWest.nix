{pkgs, ...}: {
  enable = true;
  autoEnable = true;
  image = ../wallpapers/fatty.jpg;
  base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-sea.yaml";
  fonts = {
    monospace = {
      package = pkgs.nerd-fonts.iosevka;
      name = "Iosevka NFM";
    };
  };
  targets = {
    # nvf.enable = true;
    # firefox.profileNames = [ "jyeno" ];
    qt = {
      enable = true;
      platform = pkgs.lib.mkForce "kde";
    };
  };
}
