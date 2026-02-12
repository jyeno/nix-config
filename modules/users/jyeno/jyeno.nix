{
  self,
  lib,
  ...
}: {
  # desktop version, factory is already implemented on jyeno-cli thus needs only to import
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

      homeManager.jyeno = {pkgs, ...}: {
        imports = with self.modules.homeManager; [
          system-desktop

          cli-fish
          cli-tmux
          cli-git
          cli-nvf
          cli-gpg
          cli-ssh
          cli-neomutt
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
          nix-output-monitor
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
          # zeal
        ];
      };
    }
  ];
}
