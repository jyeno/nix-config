{
  self,
  lib,
  ...
}: {
  flake = let
    users = ["jlato" "cassio" "igorcafe" "oliver" "leonardohn"];
  in {
    homeConfigurations = lib.mkMerge [
      (builtins.map (username: self.lib.mkHomeManager "aarch64-linux" "${username}")
        users)
    ];
    modules = lib.mkMerge (
      (builtins.map (username: (lib.mkMerge [
          (self.factory.user "${username}" true)
          {
            nixos."${username}" = {
              users.users."${username}" = {
                openssh.authorizedKeys.keys = [
                  (builtins.readFile ../../../extras/pubkeys/id_${username}.pub)
                ];
              };
            };

            homeManager."${username}" = {
              imports = with self.modules.homeManager; [
                system-cli
              ];
            };
          }
        ]))
        users)
      ++ [
        {
          nixos.nirvana = {
            imports = builtins.map (username: (builtins.getAttr "${username}" self.modules.nixos)) users;
          };
        }
      ]
    );
  };
}
