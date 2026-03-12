{
  self,
  lib,
  ...
}:
{
  flake =
    let
      users = [
        "jaque"
      ];
    in
    {
      homeConfigurations = lib.mkMerge [
        (builtins.map (username: self.lib.mkHomeManager "x86_64-linux" "${username}") users)
      ];
      modules = lib.mkMerge (
        (builtins.map (
          username:
          (lib.mkMerge [
            (self.factory.user "${username}" true)
            {
              nixos."${username}" = {
                users.users."${username}".initialHashedPassword =
                  "$y$j9T$QEk2jvCnblyKUNmkB0Z4o.$h4621Dq2jyNUrjP6AjYQWzQ/mvld783fd.6X5JQtm58";
                users.users."${username}" = {
                  openssh.authorizedKeys.keys = [
                    (builtins.readFile ../../../extras/pubkeys/id_jyeno.pub)
                  ];
                };
              };

              homeManager."${username}" =
                { pkgs, ... }:
                {
                  imports = with self.modules.homeManager; [
                    system-desktop

                    cli-fish
                    cli-tmux
                    cli-git
                    cli-nvf
                    cli-players

                    desktop-general
                    desktop-firefox
                    desktop-ghostty
                  ];
                  home.packages = with pkgs; [
                    zip
                    xz
                    unzip
                    unrar
                    p7zip
                    materialgram
                  ];
                };
            }
          ])
        ) users)
        ++ [
          {
            nixos.marga.imports = builtins.map (
              username: (builtins.getAttr "${username}" self.modules.nixos)
            ) users;
          }
        ]
      );
    };
}
