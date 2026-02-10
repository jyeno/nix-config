{
  self,
  lib,
  ...
}: {
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

      # TODO personalize some modules like the ssh one
      homeManager.jyeno = {pkgs, ...}: {
        imports = with self.modules.homeManager; [
          system-desktop

          cli-fish
          cli-tmux
          cli-git
          cli-ssh
          cli-gpg
          cli-neomutt
          cli-nvf
          cli-newsboat

          desktop-wlr
          desktop-firefox
          desktop-chromium
          desktop-qutebrowser
          desktop-ashell
          desktop-ghostty
          desktop-idlelock
          desktop-niri
          desktop-hyprland
          desktop-plasma

          emu-switch
        ];
        home.packages = with pkgs; [
          #cli
          zip
          xz
          unzip
          p7zip
          strace
          age
          spotdl
          nix-output-monitor

          #desktop
          keepassxc
          pavucontrol
          lmstudio
          r2modman
          vesktop
          materialgram
          mumble
          # zeal
        ];
      };
    }
  ];
}
