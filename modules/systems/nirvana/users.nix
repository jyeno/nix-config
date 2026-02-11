{
  inputs,
  lib,
  ...
}: let
  mkUser = name: deps: packages: {inherit name deps packages;};
  mkUserName = name: mkUser name [] [];
  users = [(mkUserName "cassio") (mkUserName "igorcafe") (mkUserName "oliver") (mkUserName "leonardohn") (mkUser "jyeno" (with inputs.self.moudles.homeManager; [tmux git fish nvf]) [])];
in {
  flake.modules = lib.mkMerge [
    (builtins.map (user:
      lib.mkMerge [
        (inputs.self.factory.user "${user.name}" true)
        {
          nixos."vps-${user.name}" = {
            users.users."${user.name}" = {
              openssh.authorizedKeys.keys = [
                (builtins.readFile "../../extras/pubkeys/id_${user.name}.pub")
              ];
            };
          };

          homeManager."vps-${user.name}" = {
            imports = with inputs.self.modules.homeManager;
              [
                system-cli
              ]
              ++ user.deps;
            home.packages = user.packages;
          };
        }
      ])
    users)
    {
      nixos.nirvana = {
        imports = builtins.map (user: inputs.self.modules.nixos.vps- "${user.name}") users;
      };
    }
  ];
}
