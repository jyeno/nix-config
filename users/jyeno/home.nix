{pkgs, ...}: {
  # ../../modules/home/cli/gpg.nix # TODO, not working disabled for now

  home.username = "jyeno";
  home.homeDirectory = "/home/jyeno";
  home.packages = with pkgs; [
    zip
    xz
    unzip
    p7zip
    ripgrep
    jq
    eza
    dnsutils
    socat
    nmap
    file
    which
    gnused
    gnutar
    gawk
    btop
    strace
    lsof
    lm_sensors
    usbutils
    pciutils
    keepassxc
    mangohud
    pavucontrol
    pamixer
    age
    spotdl
    lmstudio
    r2modman
    # _64gram
    vesktop

    # TODO optimize packages list
    # programming
    zeal-qt6
  ];

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "24.05";

  local.home = {
    cli = {
      fish = {
        enable = true;
        starship.enable = true;
      };
      git.enable = true;
      gpg.enable = true;
      mpd.enable = true;
      neomutt.enable = true;
      neovim.enable = false;
      newsboat.enable = true;
      nvf.enable = true;
      fd.enable = true;
      fzf.enable = true;
      aria2.enable = true;
      bat.enable = true;
      ssh.enable = true;
      tmux.enable = true;
      direnv.enable = true;
      pass.enable = true;
      pass-secret-service.enable = false;
      yt-dlp.enable = true;
      mpv.enable = true;
      browserpass.enable = true;
    };
    desktop = {
      chromium.enable = true;
      firefox.enable = true;
      ghostty.enable = true;
      zathura.enable = true;
    };
    misc = {
      persistent.enable = true;
      sops.enable = true;
      sound.enable = true;
    };
    wayland = {
      enable = true;
      cliphist.enable = true;
      fnott.enable = true;
      foot.enable = true;
      hypridle.enable = true;
      hyprland.enable = true;
      hyprlock.enable = true;
      river.enable = false;
      ashell.enable = true;
      gbar.enable = false;
      waybar.enable = false;
      wofi.enable = true;
      yambar.enable = false;
    };
  };
}
