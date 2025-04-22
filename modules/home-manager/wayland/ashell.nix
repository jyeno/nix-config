{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.home.wayland.ashell;
in {
  #TODO add more options
  options.local.home.wayland.ashell.enable = lib.mkEnableOption "Enable ashell configuration";
  config = lib.mkIf cfg.enable {
    systemd.user.services.ashell = {
      Unit = {
        Description = "ashell service.";
        Documentation = "https://github.com/MalpenZibo/ashell";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target" "sound.target"];
        ConditionEnvironment = ["HYPRLAND_INSTANCE_SIGNATURE"];
      };
      Install.WantedBy = ["graphical-session.target"];
      Service = {
        ExecStart = "${lib.getExe pkgs.ashell}";
        Restart = "on-failure";
      };
    };

    # xdg.configFile."ashell/config.toml" = let
    xdg.configFile."ashell.yml" = let
      terminal = lib.getExe pkgs.ghostty;
      pavucontrol = lib.getExe pkgs.pavucontrol;
      lockCmd = "${lib.getExe pkgs.hyprlock} &";
      clockFormat = "%a %d %b %R";
      launcher = lib.getExe config.programs.wofi.package;
      cliphist = lib.getExe config.services.cliphist.package;
      clipboard = "selected=$(${cliphist} list | ${launcher} -S dmenu) && echo \"$selected\" | ${cliphist} decode | wl-copy";
      textCap = "150";
      fontName = "Comic Sans MS"; # TODO change
      backgroundColor = "#1e1e2e";
      primaryColor = "#fab387";
      secondaryColor = "#11111b";
      successColor = "#a6e3a1";
      dangerColor = "#f38ba8";
      textColor = "#f38ba8";
    in {
      text = ''
        logLevel: "WARN"
        outputs: All
        position: Bottom
        appLauncherCmd: "${launcher}"
        clipboardCmd: '${clipboard}'
        truncateTitleAfterLength: ${textCap}

        modules:
        # The modules that will be displayed on the left side of the status bar
          left:
            - AppLauncher
            - Workspaces
            - WindowTitle
          center:
            -  MediaPlayer
          right:
            - Tray
            - SystemInfo
            - [ Clock, Clipboard, Privacy, Settings ]

        workspaces:
          visibilityMode: All
          enableWorkspaceFilling: false

        system:
          cpuWarnThreshold: 60
          cpuAlertThreshold: 80
          memWarnThreshold: 70
          memAlertThreshold: 85
          tempWarnThreshold: 60
          tempAlertThreshold: 80

        clock:
          format: "${clockFormat}"

        mediaPlayer:
          maxTitleLength: ${textCap}

        settings:
          lockCmd: "${lockCmd}"
          audioSinksMoreCmd: "${pavucontrol} -t 3"
          audioSourcesMoreCmd: "${pavucontrol} -t 4"
          wifiMoreCmd: "${terminal} --command=iwctl"
          vpnMoreCmd: "${terminal} --command=iwctl"
          bluetoothMoreCmd: "${terminal} --command=bluetoothctl"

        appearance:
          fontName: "${fontName}"
          style: "islands"
          opacity: 1.0
          backgroundColor: "${backgroundColor}"
          primaryColor: "${primaryColor}"
          secondaryColor: "${secondaryColor}"
          successColor: "${successColor}"
          dangerColor: "${dangerColor}"
          textColor: "${textColor}"
          workspaceColors:
            - "#fab387"
            - "#b4befe"
          specialWorkspaceColors:
            - "#a6e3a1"
            - "#f38ba8"
      '';
    };
  };
}
