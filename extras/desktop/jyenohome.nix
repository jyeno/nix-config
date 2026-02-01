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
    mumble
    # inputplumber
    # evremap
    # input-remapper
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
    emu.switch = {
      enable = true;
      gameDirs = ["/home/games/switch"];
      resolutionScaling = 1440;
      antialiasing = "SmaaUltra";
      aspectRatio = "21:9";
      dramSize = 8;
      extraConfig = {
        input_config = [
          {
            left_joycon_stick = {
              stick_up = "W";
              stick_down = "S";
              stick_left = "A";
              stick_right = "D";
              stick_button = "F";
            };
            right_joycon_stick = {
              stick_up = "I";
              stick_down = "K";
              stick_left = "J";
              stick_right = "L";
              stick_button = "H";
            };
            left_joycon = {
              button_minus = "Minus";
              button_l = "Shift";
              button_zl = "Z";
              button_sl = "Unbound";
              button_sr = "Unbound";
              dpad_up = "Up";
              dpad_down = "Down";
              dpad_left = "Left";
              dpad_right = "Right";
            };
            right_joycon = {
              button_plus = "Plus";
              button_r = "ShiftLeft";
              button_zr = "O";
              button_sl = "Unbound";
              button_sr = "Unbound";
              button_x = "C";
              button_b = "Space";
              button_y = "F";
              button_a = "E";
            };
            version = 1;
            backend = "WindowKeyboard";
            id = "0";
            name = "Keyboard";
            controller_type = "ProController";
            player_index = "Player1";
          }
        ];
      };
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
          ghostty = {
            enable = true;
            # settings = {
            #   mouse-hide-while-typing = true;
            #   copy-on-select = true;
            #   gtk-titlebar = false;
            #   gtk-tabs-location = "hidden";
            #   window-save-state = "always";
            #   window-decoration = "none";
            #   term = "xterm-256color";
            #   keybind = [
            #     # keybindings for panes/splits
            #     "ctrl+s>\=new_split:right"
            #     "ctrl+s>-=new_split:down"
            #     "ctrl+s>x=close_surface"
            #     "ctrl+s>enter=toggle_split_zoom"
            #     # navigation between splits
            #     "ctrl+s>h=goto_split:left"
            #     "ctrl+s>j=goto_split:bottom"
            #     "ctrl+s>k=goto_split:top"
            #     "ctrl+s>l=goto_split:right"
            #     # tab management
            #     "ctrl+shift+left=previous_tab"
            #     "ctrl+shift+right=next_tab"
            #     "ctrl+s>c=new_tab"
            #     # quick tab switching
            #     "ctrl+tab=next_tab"
            #     "ctrl+s>arrow_left=previous_tab"
            #     "ctrl+s>arrow_right=next_tab"
            #     "ctrl+s>1=goto_tab:1"
            #     "ctrl+s>2=goto_tab:2"
            #     "ctrl+s>3=goto_tab:3"
            #     "ctrl+s>4=goto_tab:4"
            #     "ctrl+s>5=goto_tab:5"
            #     "ctrl+s>6=goto_tab:6"
            #     "ctrl+s>7=goto_tab:7"
            #     "ctrl+s>8=goto_tab:8"
            #     "ctrl+s>9=goto_tab:9"
            #   ];
            # };
          };
          zathura.enable = true;
          cliphist.enable = true;
          plasma.enable = true;
        }
        jyenowlr
      ];
    misc = {
      persistent = {
        enable = true;
        directoriesPrivate = [
          ".config/sops"
          ".gnupg"
          ".password-store"
          ".nixos"
          # ".ssh"
          ".local/share/direnv"
          ".local/share/fish"
          ".local/state/wireplumber"
        ];
        directories = [
          "Music"
          ".config/chromium"
          ".config/qutebrowser/greasemonkey"
          ".cache/lm-studio"
          ".config/Ryujinx"
          # ".config/r2modman"
          # ".config/r2modmanPlus-local"
          ".config/vesktop"
          ".config/wivrn"
          ".mozilla/firefox/jyeno"
          ".local/share/materialgram"
          ".local/share/qutebrowser"
          ".local/share/Steam"
          ".local/share/containers"
        ];
        files = [
          ".Passwords.kdbx"
          ".ssh/known_hosts"
        ];
      };
      sops.enable = true;
      sound.enable = true;
    };
  };
}
