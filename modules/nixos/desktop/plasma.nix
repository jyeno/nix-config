{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.desktop.plasma;
in {
  options.local.desktop.plasma.enable = lib.mkEnableOption "Enable Plasma6 configuration";
  config = lib.mkIf cfg.enable {
    services.desktopManager.plasma6.enable = true;
    # TODO remove it, bug https://github.com/nix-community/stylix/issues/1092
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";
    };
  };
}
