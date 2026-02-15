{inputs, ...}: {
  flake.modules.nixos.stylix-jyeno = {pkgs, ...}: {
    imports = [inputs.self.modules.nixos.stylix];
    stylix = {
      enable = true;
      autoEnable = true;
      image = ./wallpapers/fatty.jpg;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-sea.yaml";
      cursor = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 32;
      };
      fonts = {
        monospace = {
          package = pkgs.iosevka;
          name = "Iosevka Term";
        };

        serif = {
          package = pkgs.iosevka;
          name = "Iosevka Slab";
        };

        sansSerif = {
          package = pkgs.iosevka;
          name = "Iosevka";
        };

        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
      targets = {
        qt = {
          enable = true;
          platform = pkgs.lib.mkForce "kde";
        };
      };
    };
  };
}
