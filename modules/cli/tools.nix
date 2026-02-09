{
  flake.modules.nixos.cli-tools = let
    genericPackages = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        git
        neovim
        tmux
        gnumake
        curl
        libnotify
      ];
    };
  in {
    imports = [
      genericPackages
    ];
    environment.variables.EDITOR = "nvim";

    programs.mtr.enable = true; # TODO consider removal

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    console.useXkbConfig = true;
  };

  flake.modules.homeManager.cli-tools = {
    programs = {
      # TODO maybe move
      aria2.enable = true;
      bat.enable = true;
      fzf.enable = true;
      fd.enable = true;
      home-manager.enable = true;
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      # nix-ld
    };
  };
}
