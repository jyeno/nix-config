{
  config,
  lib,
  ...
}: let
  cfg = config.local.desktop.wireshark;
in {
  options.local.desktop.wireshark.enable = lib.mkEnableOption "Enable wireshark configuration";
  config = lib.mkIf cfg.enable {
    programs.wireshark.enable = lib.mkDefault true;
  };
}
