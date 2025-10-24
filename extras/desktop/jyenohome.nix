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
    lmstudio
    r2modman
    vesktop
    materialgram
    ghostty
    mumble
    # zeal
  ];

  home.file.".config/kwinoutputconfig.json".text = builtins.toJSON [
    {
      data = [
        {
          allowSdrSoftwareBrightness = true;
          autoRotation = "InTabletMode";
          brightness = 1;
          colorPowerTradeoff = "PreferEfficiency";
          colorProfileSource = "sRGB";
          connectorName = "DP-3";
          edidHash = "b3e79804fc4869bddefc8ec3849f2628";
          edidIdentifier = "ICB 13312 0 22 2022 0";
          highDynamicRange = true;
          iccProfilePath = "";
          mode = {
            height = 1440;
            refreshRate = 165001;
            width = 3440;
          };
          overscan = 0;
          rgbRange = "Automatic";
          scale = 1;
          sdrBrightness = 250;
          sdrGamutWideness = 0;
          transform = "Instant";
          vrrPolicy = "Automatic";
          wideColorGamut = true;
        }
      ];
      name = "outputs";
    }
    {
      data = [
        {
          lidClosed = false;
          outputs = [
            {
              enabled = true;
              outputIndex = 0;
              position = {
                x = 0;
                y = 0;
              };
              priority = 0;
            }
          ];
        }
      ];
      name = "setups";
    }
  ];

  local.home = {
    cli = {
      fish = {
        enable = true;
        starship.enable = true;
      };
      git = {
        enable = true;
        delta.enable = true;
        settings = {
          user = {
            name = "Jean Lima Andrade";
            email = "jeno.andrade@gmail.com";
          };
          alias = {
            co = "checkout";
            unstage = "reset HEAD --";
            cm = "commit";
            cmm = "commit -p -m";
            st = "status -s";
            br = "branch";
            fp = "fetch -p";
            lfive = "log -5 HEAD --decorate  --oneline --graph";
            l = "log --pretty=format:\"%C(yellow)%h %ad%Cred%d %Creset%s%Cblue [%cn]\" --decorate --date=relative --graph";
            ds = "diff --staged";
            d = "diff --word-diff";
            cl = "clone";
            rb = "rebase";
            pll = "pull origin";
            psh = "push origin";
          };
          core = {
            whitespace = "trailing-space,space-before-tab";
            editor = "nvim";
          };
          url = {
            "https://gitlab.com/" = {
              insteadOf = "gl:";
            };
            "https://github.com/" = {
              insteadOf = "gh:";
            };
          };
          pull.rebase = true;
          init.defaultBranch = "master";
        };
      };
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
      ssh = {
        enable = true;
        ed25519Pubkey = builtins.readFile ../pubkeys/id_jyeno.pub;
        matchBlocks = {
          "*" = {
            addKeysToAgent = "4h";
          };
          openwrt = {
            hostname = "192.168.1.1";
            user = "root";
          };
          alph = {
            hostname = "192.168.1.248";
            user = "root";
          };
          nirvana = {
            hostname = "nirvana.jyeno.cc";
            user = "jyeno";
          };
        };
      };
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
          chromium.enable = true;
          firefox.enable = true;
          qutebrowser.enable = true;
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
          ".local/share/qutebrowser"
          ".local/share/direnv"
          ".local/share/fish"
          ".local/state/wireplumber"
          ".config/sops"
          # ".config/r2modman"
          # ".config/r2modmanPlus-local"
          ".config/chromium"
          ".config/vesktop"
          ".config/qutebrowser/greasemonkey"
          ".config/wivrn"
          ".password-store"
          ".nixos"
        ];
        directoriesSymlink = [
          ".local/share/Steam"
          ".local/share/containers"
          ".cache/lm-studio"
        ];
        files = [
          ".ssh/known_hosts"
          ".Passwords.kdbx"
        ];
      };
      sops.enable = true;
      sound.enable = true;
    };
  };
}
