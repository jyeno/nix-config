{
  self,
  lib,
  ...
}:
{
  flake.modules = lib.mkMerge [
    (self.factory.user "jyeno" true)
    {
      nixos.jyeno = {
        users.users.jyeno = {
          openssh.authorizedKeys.keys = [
            (builtins.readFile ../../../extras/pubkeys/id_jyeno.pub)
          ];
        };
      };

      homeManager.jyeno =
        {
          pkgs,
          specialArgs,
          ...
        }:
        let
          graphicsEnabled = specialArgs.graphicsEnabled or false;
          niriEnabled = specialArgs.niriEnabled or false;
          hyprlandEnabled = specialArgs.hyprlandEnabled or false;
          plasmaEnabled = specialArgs.plasmaEnabled or false;
          wlrEnabled = niriEnabled || hyprlandEnabled;
        in
        {
          imports =
            with self.modules.homeManager;
            [
              system-cli

              cli-fish
              cli-tmux
              cli-git
              cli-nvf
            ]
            ++ lib.optionals graphicsEnabled [
              cli-pass
              cli-players
              cli-mpd

              desktop-general
              cli-gpg
              # extras
              cli-ssh
              cli-neomutt
              cli-newsboat

              desktop-firefox
              # desktop-chromium
              desktop-qutebrowser
              desktop-ghostty
              emu-switch
            ]
            ++ lib.optionals wlrEnabled [
              desktop-wlr
              desktop-ashell
              desktop-idlelock
            ]
            ++ lib.optionals niriEnabled [
              desktop-niri
            ]
            ++ lib.optionals hyprlandEnabled [
              desktop-hyprland
            ]
            ++ lib.optionals plasmaEnabled [
              desktop-plasma
            ];
          home.pointerCursor.enable = true;
          home.packages =
            with pkgs;
            [
              #cli
              zip
              xz
              unzip
              p7zip
              strace
              nix-output-monitor
              zmx
            ]
            ++ lib.optionals graphicsEnabled [
              age
              spotdl

              #desktop
              keepassxc
              pavucontrol
              lmstudio
              r2modman
              vesktop
              materialgram
              mumble
              ffmpeg
              libopus
              # zeal
            ];
          programs.git.settings.user = {
            name = "Jean Lima Andrade";
            email = "jeno.andrade@gmail.com";
          };
        };
    }
  ];
}
