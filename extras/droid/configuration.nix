{
  lib,
  pkgs,
  ...
}: {
  # documentation.man.enable = false;
  environment.packages = with pkgs; [
    neovim
    git
    curl
  ];
  environment.etcBackupExtension = ".bak";

  user = {
    shell = pkgs.fish;
    # userName = "jyeno";
  };

  terminal = {
    colors = {
      background = "181818";
      foreground = "FFFFFF";
      cursor = "585858";
      color0 = "22273d";
      color1 = "374059";
      color2 = "525866";
      color3 = "878d96";
      color4 = "c8c8c8";
      color5 = "ffffff";
      color6 = "ffffff";
      color7 = "ffffff";
      color8 = "fa7883";
      color9 = "ffc387";
      color10 = "ff9470";
      color11 = "98c379";
      color12 = "8af5ff";
      color13 = "6bb8ff";
      color14 = "e799ff";
      color15 = "b3684f";
    };
    # font = pkgs.nerd-fonts.iosevka;
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes pipe-operators
  '';
  time.timeZone = "America/Bahia";

  home-manager.config = {
    programs.home-manager.enable = true;
    systemd.user.startServices = "sd-switch";
    home = {
      packages = with pkgs; [
        xz
        ripgrep
        jq
        eza
        dnsutils
        socat
        nmap
        file
        which
        gnutar
        strace
        nix-output-monitor
      ];

      stateVersion = "24.05";
    };

    local.home.cli = {
      fish = {
        enable = true;
        starship.enable = true;
      };
      git.enable = true;
      gpg.enable = true;
      nvf.enable = true;
      fd.enable = true;
      fzf.enable = true;
      aria2.enable = true;
      bat.enable = true;
      ssh.enable = true;
      tmux.enable = true;
      direnv.enable = true;
    };
  };

  system.stateVersion = "24.05";
}
