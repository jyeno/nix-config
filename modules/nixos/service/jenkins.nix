{
  config,
  lib,
  ...
}: let
  cfg = config.local.service.jenkins;
in {
  options.local.service.jenkins.enable = lib.mkEnableOption "Enable jenkins";
  config = lib.mkIf cfg.enable {
    services.jenkins.enable = lib.mkDefault true;
  };
}
