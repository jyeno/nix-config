{ inputs, ... }:
{
  # convenience function to set persistence settings only,
  # if impermanence module was imported

  flake.lib = {
    mkIfPersistence =
      config: settings:
      if config ? home then
        (if config.home ? persistence then settings else { })
      else
        (if config.environment ? persistence then settings else { });
  };

  flake.modules.nixos.impermanence =
    { config, lib, ... }:
    {
      imports = [
        inputs.impermanence.nixosModules.impermanence
      ];

      system.activationScripts.persistent-dirs.text =
        let
          mkHomePersist =
            user:
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
