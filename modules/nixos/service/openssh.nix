{
  config,
  lib,
  ...
}: let
  cfg = config.local.service.openssh;
in {
  options.local.service.openssh = {
    enable = lib.mkEnableOption "Enable ssh service";
    sopsKeyPath = lib.mkOption {
      type = lib.types.str;
      default = "/persist/etc/ssh/ssh_host_ed25519_key";
      description = "ed25519 SSH key path to SOPS enablement";
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      openssh = {
        enable = lib.mkDefault true;
        hostKeys = [
          # TODO maybe add multiple keys
          {
            path = cfg.sopsKeyPath;
            type = "ed25519";
          }
        ];
      };
      # TODO move
      fstrim.enable = true;
    };
  };
}
