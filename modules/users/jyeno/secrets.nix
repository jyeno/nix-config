{inputs, ...}: {
  flake.modules.nixos.jyeno = {
    self,
    config,
    ...
  }: {
    imports = [
      inputs.self.modules.nixos.secrets
    ];
    users.users.jyeno.hashedPasswordFile = config.age.secrets.jyeno-pass.path;
    age = {
      secrets."jyeno-pass".file = "${inputs.secrets}/users/jyeno.age";
      secrets."jyeno-key" = {
        file = "${inputs.secrets}/users/jyeno-key.age";
        path = "${config.home-manager.users.jyeno.home.homeDirectory}/.ssh/id_ed25519";
        mode = "0700";
        owner = "jyeno";
        group = "jyeno";
      };
    };
  };

  flake.modules.homeManager.jyeno = {config, ...}: {
    imports = [
      inputs.self.modules.homeManager.secrets
    ]; # the best would be to add jyeno-key here but cant because the default key requires password
  };
}
