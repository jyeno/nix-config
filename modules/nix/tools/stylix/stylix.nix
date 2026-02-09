{inputs, ...}: {
  flake.modules.nixos.stylix = {pkgs, ...}: {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];
    stylix = {
      enable = true;
      autoEnable = true;
      image = ../../../../extras/wallpapers/fatty.jpg;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-sea.yaml";
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.iosevka;
          name = "Iosevka NFM";
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
