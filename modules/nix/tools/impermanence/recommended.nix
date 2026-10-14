{
  flake.modules.nixos.impermanence =
    {
      config,
      lib,
      ...
    }:
    {
      environment.persistence."${config.systemConstants.persistDir}" = {
        hideMounts = true;
        directories = [
          "/etc/ssh/"
          "/var/log"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
        ]
        ++ lib.optionals config.networking.networkmanager.enable [
          "/etc/NetworkManager/system-connections"
        ]
        ++ lib.optionals config.services.tailscale.enable [
          "/var/lib/tailscale"
        ]
        ++ lib.optionals config.networking.wireless.iwd.enable [
          "/var/lib/iwd"
        ];
        files = [
          "/etc/machine-id"
        ];
      };
      programs.fuse.userAllowOther = true;
    };
}
