{pkgs, ...}: {
  home.username = "user";
  home.homeDirectory = "/home/user";

  home.packages = with pkgs; [
    neovim
    fish
    tmux
    git
    #    zip
    #    xz
    #    unzip
    #    p7zip
    #    ripgrep
    #    jq
    #    eza
    #    dnsutils
    #    socat
    #    nmap
    #    file
    #    which
    #    gnused
    #    gnutar
    #    gawk
    #    strace
    #    lsof
    #    lm_sensors
    #    usbutils
    #    pciutils
    #    age
    #    nix-output-monitor
  ];

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "25.05";

  # local.home = {
  #   cli = {
  # fish = {
  #   enable = true;
  # starship.enable = true;
  # };
  # git.enable = true;
  # gpg.enable = true;
  # nvf.enable = true;
  # fd.enable = true;
  # fzf.enable = true;
  # aria2.enable = true;
  # bat.enable = true;
  # ssh.enable = true;
  # direnv.enable = true;
  # yt-dlp.enable = true;
  # };
  # };
}
