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
    age.secrets."jyeno-pass".file = "${inputs.secrets}/users/jyeno.age";
  };

  flake.modules.homeManager.jyeno = {
    self,
    config,
    ...
  }: {
    imports = [
      inputs.self.modules.homeManager.secrets
    ];
    age.secrets."jyeno-key" = {
      file = "${inputs.secrets}/users/jyeno-key.age";
      path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      mode = "0700";
    };
  };
}
