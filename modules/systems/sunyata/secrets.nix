{ inputs, ... }:
{
  flake.modules.nixos.sunyata =
    { config, ... }:
    {
      users.users.root.hashedPasswordFile = config.age.secrets.root-pass.path;

      age = {
        identityPaths = [ "${config.systemConstants.persistDir}/etc/ssh/ssh_host_ed25519_key" ];
        secrets."root-pass".file = "${inputs.secrets}/users/root.age";
      };
    };
}
