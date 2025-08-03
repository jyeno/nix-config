{
  config,
  lib,
  ...
}: let
  cfg = config.local.service.openssh;
in {
  options.local.service.openssh = {
    enable = lib.mkEnableOption "Enable ssh service";
    hostKeys = lib.mkOption {
      type = with lib.types; nullOr (listOf attrs);
      default = [
        {
          path = "/persist/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
      description = "list of keys path, mainly to SOPS enablement";
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      openssh = {
        enable = lib.mkDefault true;
        hostKeys = cfg.hostKeys;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
        };
      };
      # TODO move
      fstrim.enable = true;
    };
  };
}
