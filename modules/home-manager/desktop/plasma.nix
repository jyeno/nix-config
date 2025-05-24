{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.home.desktop.plasma;
in {
  options.local.home.desktop.plasma = {
    enable = lib.mkEnableOption "Enable plasma configuration";
  };
  config = lib.mkIf cfg.enable {
    programs.plasma = {
      enable = true;

      workspace = {
        clickItemTo = "select";
        lookAndFeel = "org.kde.breezedark.desktop";
        cursor.theme = "Bibata-Modern-Ice";
        iconTheme = "Papirus-Dark";
        # wallpaper = cfg.fileLocation;
      };

      hotkeys.commands."launch-konsole" = {
        name = "Launch Konsole";
        key = "Meta+Enter";
        command = "konsole";
      };

      panels = [
        # Windows-like panel at the bottom
        {
          location = "bottom";
          widgets = [
            "org.kde.plasma.kickoff"
            "org.kde.plasma.icontasks"
            "org.kde.plasma.marginsseparator"
            "org.kde.plasma.systemtray"
            "org.kde.plasma.digitalclock"
          ];
        }
        # Global menu at the top
        # {
        #   location = "left";
        #   # height = 26;
        #   widgets = ["org.kde.plasma.appmenu"];
        # }
      ];

      #
      # Some mid-level settings:
      #
      shortcuts = {
        ksmserver = {
          "Lock Session" = [
            "Screensaver"
            "Meta+Ctrl+Alt+L"
          ];
        };

        kwin = {
          "Expose" = "Meta+,";
          "Switch Window Down" = "Meta+J";
          "Switch Window Left" = "Meta+H";
          "Switch Window Right" = "Meta+L";
          "Switch Window Up" = "Meta+K";
        };
      };

      #
      # Some low-level settings:
      #
      configFile = {
        "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
        "kwinrc"."org.kde.kdecoration2"."ButtonsOnLeft" = "SF";
        "kwinrc"."Desktops"."Number" = {
          value = 8;
          # Forces kde to not change this value (even through the settings app).
          immutable = true;
        };
      };
    };
  };
}
