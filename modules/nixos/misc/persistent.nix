{
  config,
  lib,
  ...
}: let
  cfg = config.local.misc.persistent;
  # TODO add a more refined way to add additionalPersistentDirectories
  additionalPersistentDirectories =
    lib.optionals config.local.service.mysql.enable ["/var/lib/mysql"]
    ++ lib.optionals config.local.service.postgres.enable ["/var/lib/postgresql"]
    ++ lib.optionals config.local.service.bluetooth.enable ["/var/lib/bluetooth"]
    ++ lib.optionals config.local.service.podman.enable ["/var/lib/containers"];
in {
  options.local.misc.persistent = {
    enable = lib.mkEnableOption "Enable impermanence (root on RAM) setup";
    persistentDirectories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "/etc/nixos"
        "/etc/ssh"
        "/var/log"
        "/var/lib/nixos"
      ];
      description = "Directories to mantain in the persistent storage";
    };
    persistentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "/etc/machine-id"
      ];
      description = "Files to symlink to the persistent storage";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.persistence."/persist" = {
      enable = lib.mkDefault true;
      hideMounts = lib.mkDefault true;
      directories = cfg.persistentDirectories ++ additionalPersistentDirectories;
      files = cfg.persistentFiles;
    };
    programs.fuse.userAllowOther = lib.mkDefault true;

    system.activationScripts.persistent-dirs.text = let
      mkHomePersist = user:
        lib.optionalString user.createHome ''
          mkdir -p /persist/${user.home}
          chown ${user.name}:${user.group} /persist/${user.home}
          chmod ${user.homeMode} /persist/${user.home}
        '';
      users = lib.attrValues config.users.users;
    in
      lib.concatLines (map mkHomePersist users);
  };
}
