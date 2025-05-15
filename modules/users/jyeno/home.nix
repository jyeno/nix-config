{pkgs, ...}: {
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
      persistent = {
        enable = true;
        directories = [
          ".gnupg"
          "music"
          ".mozilla/firefox/jyeno"
          ".local/share/materialgram"
          ".local/share/direnv"
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
          ".cache/lm-studio"
        ];
        files = [
          ".local/share/fish/fish_history"
          ".ssh/known_hosts"
          ".Passwords.kdbx"
        ];
      };
      sops.enable = true;
      sound.enable = true;
    };
    wayland = {
      enable = true;
      cliphist.enable = true;
      fnott.enable = true;
      foot.enable = true;
      hypridle.enable = true;
      hyprland = {
        enable = true;
        wallpaperPath = ../../../extras/wallpapers/dragon.jpg;
        #TODO only enable it if hdr is enabled
        extraConfig = ''
          monitor = DP-1, 3440x1440@165, 0x0, 1, bitdepth, 10, cm, hdr, sdrbrightness, 1.2, sdrsaturation, 0.98
        '';
        keyboard = {
          layout = "us,us";
          variant = ",workman-intl";
          options = "ctrl:nocaps,grp:win_space_toggle";
        };
        animations.enable = false;
        binds = {
          config = let
            grimblast = pkgs.lib.getExe pkgs.grimblast;
            steam = "/run/current-system/sw/bin/steam";
            telegram = pkgs.lib.getExe pkgs.materialgram;
            light = pkgs.lib.getExe pkgs.light;
            foot = pkgs.lib.getExe' pkgs.foot "footclient";
            ghostty = pkgs.lib.getExe pkgs.ghostty;
            tesseract = pkgs.lib.getExe pkgs.tesseract;
            pactl = pkgs.lib.getExe' pkgs.pulseaudio "pactl";
            notify-send = pkgs.lib.getExe' pkgs.libnotify "notify-send";
            defaultApp = type: "${pkgs.lib.getExe pkgs.handlr-regex} launch ${type}";
          in [
            # Program bindings
            "$mainMod, Return, exec, ${foot} sh -c 'tmux at -t 0 || tmux'"
            "$mainMod ALT, Return, exec, ${ghostty}"
            # "$mainMod, Return, exec, ${defaultApp "x-scheme-handler/terminal"}"
            "$mainMod, e, exec, ${defaultApp "text/plain"}"
            "$mainMod, b, exec, ${defaultApp "x-scheme-handler/https"}"
            "$mainMod, s, exec, ${steam}"
            "$mainMod, t, exec, ${telegram}"
            # Brightness control (only works if the system has lightd)
            ", XF86MonBrightnessUp, exec, ${light} -A 10"
            ", XF86MonBrightnessDown, exec, ${light} -U 10"
            # Volume
            ", XF86AudioRaiseVolume, exec, ${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
            ", XF86AudioLowerVolume, exec, ${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
            ", XF86AudioMute, exec, ${pactl} set-sink-mute @DEFAULT_SINK@ toggle"
            "SHIFT, XF86AudioMute, exec, ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
            ", XF86AudioMicMute, exec, ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
            # Screenshotting
            ", Print, exec, ${grimblast} --notify copy output"
            "$mainMod, Print, exec, ${grimblast} --notify copy area"
            # To OCR
            "ALT, Print, exec, ${grimblast} save area - | ${tesseract} - - | wl-copy && ${notify-send} -t 3000 'OCR result copied to buffer'"
          ];
          enableCycleWorkspaces = true;
          enableExtraBinds = true;
        };
      };
      hyprlock.enable = true;
      river.enable = false;
      ashell = {
        enable = true;
        config = let
          terminal = pkgs.lib.getExe pkgs.ghostty;
          pavucontrol = pkgs.lib.getExe pkgs.pavucontrol;
          lockCmd = "${pkgs.lib.getExe pkgs.hyprlock} &";
          clockFormat = "%a %d %b %R";
          launcher = pkgs.lib.getExe pkgs.wofi;
          cliphist = pkgs.lib.getExe pkgs.cliphist;
          clipboard = "selected=$(${cliphist} list | ${launcher} -S dmenu) && echo \"$selected\" | ${cliphist} decode | wl-copy";
          textCap = 150;
          fontName = "Comic Sans MS"; # TODO change
          backgroundColor = "#1e1e2e";
          primaryColor = "#fab387";
          secondaryColor = "#11111b";
          successColor = "#a6e3a1";
          dangerColor = "#f38ba8";
          textColor = "#f38ba8";
        in {
          logLevel = "WARN";
          outputs = "All";
          position = "Bottom";
          appLauncherCmd = launcher;
          clipboardCmd = clipboard;
          truncateTitleAfterLength = textCap;
          modules = {
            left = [
              "AppLauncher"
              "Workspaces"
              "WindowTitle"
            ];
            center = ["MediaPlayer"];
            right = [
              "Tray"
              "SystemInfo"
              ["Clock" "Clipboard" "Privacy" "Settings"]
            ];
          };
          workspaces = {
            visibilityMode = "All";
            enableWorkspaceFilling = false;
          };
          system = {
            cpuWarnThreshold = 60;
            cpuAlertThreshold = 80;
            memWarnThreshold = 70;
            memAlertThreshold = 85;
            tempWarnThreshold = 60;
            tempAlertThreshold = 80;
          };

          clock.format = clockFormat;

          mediaPlayer.maxTitleLength = textCap;

          settings = {
            lockCmd = lockCmd;
            audioSinksMoreCmd = "${pavucontrol} -t 3";
            audioSourcesMoreCmd = "${pavucontrol} -t 4";
            wifiMoreCmd = "${terminal} --command=iwctl";
            vpnMoreCmd = "${terminal} --command=iwctl";
            bluetoothMoreCmd = "${terminal} --command=bluetoothctl";
          };

          appearance = {
            fontName = fontName;
            style = "islands";
            opacity = 1.0;
            backgroundColor = backgroundColor;
            primaryColor = primaryColor;
            secondaryColor = secondaryColor;
            successColor = successColor;
            dangerColor = dangerColor;
            textColor = textColor;
            workspaceColors = [
              "#fab387"
              "#b4befe"
            ];
            specialWorkspaceColors = [
              "#a6e3a1"
              "#f38ba8"
            ];
          };
        };
      };
      gbar.enable = false;
      waybar.enable = false;
      wofi.enable = true;
      yambar.enable = false;
    };
  };
}
