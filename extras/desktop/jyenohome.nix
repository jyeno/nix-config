{pkgs, ...}: {
  home.packages = with pkgs; [
    #cli
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
    strace
    lsof
    lm_sensors
    usbutils
    pciutils
    age
    spotdl
    nix-output-monitor

    #desktop
    keepassxc
    pavucontrol
    pamixer
    lmstudio
    r2modman
    vesktop
    materialgram
    ghostty
    mumble
    zeal-qt6
  ];

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
    desktop = let
      jyenowlr = import ./jyenowlr.nix {inherit pkgs;};
    in
      pkgs.lib.mkMerge [
        {
          enable = true;
          stylix = {};
          chromium.enable = true;
          firefox.enable = true;
          ghostty.enable = true;
          zathura.enable = true;
          cliphist.enable = true;
          plasma.enable = true;
        }
        jyenowlr
      ];
    misc = {
      persistent = {
        enable = true;
        directories = [
          ".gnupg"
          "Music"
          ".mozilla/firefox/jyeno"
          ".local/share/materialgram"
          ".local/share/direnv"
          ".local/share/fish"
          ".local/state/wireplumber"
          ".config/sops"
          # ".config/r2modman"
          # ".config/r2modmanPlus-local"
          ".config/chromium"
          ".config/vesktop"
          ".password-store"
          ".nixos"
        ];
        directoriesSymlink = [
          ".local/share/Steam"
          ".local/share/containers"
          ".cache/lm-studio"
        ];
        files = [
          # ".ssh/known_hosts"
          ".Passwords.kdbx"
        ];
      };
      sops.enable = true;
      sound.enable = true;
    };
  };
}
