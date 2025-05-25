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
    home.pointerCursor = {
      x11.enable = true;
      name = "breeze_cursors";
      size = 24;
      package = pkgs.kdePackages.breeze;
    };
    # home.file."/home/${config.home.username}/.gtkrc-2.0".force = lib.mkForce true;
    # home.file."/home/${config.home.username}/.config/gtk-3.0/settings.ini".force = lib.mkForce true;
    # home.file."/home/${config.home.username}/.config/gtk-4.0/settings.ini".force = lib.mkForce true;
    gtk = {
      enable = true;
      theme.name = "Breeze";
      iconTheme.name = "breeze-dark";
      cursorTheme = {
        name = "breeze_cursors";
        size = 24;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-decoration-layout = "icon:minimize,maximize,close";
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-decoration-layout = "icon:minimize,maximize,close";
      };
    };

    programs.plasma = {
      enable = true;
      workspace = {
        clickItemTo = "select";
        colorScheme = "BreezeDark";
        lookAndFeel = "org.kde.breezedark.desktop";
        iconTheme = "breeze-dark";
        theme = "breeze-dark";
        wallpaper = ../../../extras/wallpapers/dragon.jpg;
        cursor = {
          theme = "breeze_cursors";
          size = 24;
        };
      };

      kscreenlocker.autoLock = true;

      hotkeys.commands."launch-konsole" = {
        name = "Launch Konsole";
        key = "Meta+Enter";
        command = "${pkgs.kdePackages.konsole}";
      };

      panels = [
        {
          location = "bottom";
          widgets = [
            {
              kickoff = {
                sortAlphabetically = true;
                icon = "nix-snowflake-white";
              };
            }
            {
              pager.general = {
                showWindowOutlines = true;
                showApplicationIconsOnWindowOutlines = true;
                showOnlyCurrentScreen = true;
                navigationWrapsAround = true;
                displayedText = "desktopNumber";
                selectingCurrentVirtualDesktop = "doNothing";
              };
            }
            {
              iconTasks = {
                launchers = [
                  "applications:org.kde.konsole.desktop"
                  "applications:materialgram.desktop"
                  "applications:steam.desktop"
                  "applications:chromium.desktop"
                ];
                behavior.showTasks = {
                  onlyInCurrentScreen = true;
                  onlyInCurrentDesktop = true;
                  onlyInCurrentActivity = true;
                };
              };
            }
            "org.kde.plasma.marginsseparator"
            "org.kde.plasma.systemtray"
            {
              digitalClock = {
                time = {
                  showSeconds = "always";
                  format = "24h";
                };
                calendar = {
                  firstDayOfWeek = "monday";
                  showWeekNumbers = true;
                  plugins = ["holidaysevents" "astronomicalevents"];
                };
              };
            }
            "org.kde.plasma.showdesktop"
          ];
          hiding = "none";
          floating = false;
        }
      ];

      #TODO move all conversation applications to workspace 2
      window-rules = [
        {
          description = "Plasma Desktop Workspace";
          match.window-class = {
            value = "org.kde.plasmashell";
            type = "exact";
            match-whole = false;
          };
          apply = {
            skippager = {
              value = true;
              apply = "force";
            };
            skipswitcher = {
              value = true;
              apply = "force";
            };
            skiptaskbar = {
              value = true;
              apply = "force";
            };
          };
        }
        # {
        #   description = "Vesktop";
        #   match = {
        #     window-class = {
        #       value = "vesktop";
        #       type = "exact";
        #       match-whole = false;
        #     };
        #     title = {
        #       value = "Discord$|Discord Updater";
        #       type = "regex";
        #     };
        #   };
        #   apply = {
        #     maximizehoriz = {
        #       value = true;
        #       apply = "initially";
        #     };
        #     maximizevert = {
        #       value = true;
        #       apply = "initially";
        #     };
        #     screen = {
        #       value = 1;
        #       apply = "remember";
        #     };
        #     activity = {
        #       value = "Communication";
        #       apply = "force";
        #     };
        #     desktops = {
        #       value = "Desktop_1";
        #       apply = "force";
        #     };
        #   };
        # }
      ];

      # powerdevil = {
      #   AC = {
      #     autoSuspend = {
      #       action = "nothing";
      #     };
      #     dimDisplay.enable = false;
      #     powerProfile = "performance";
      #     turnOffDisplay.idleTimeout = "never";
      #   };
      #   battery = {
      #     autoSuspend = {
      #       action = "sleep";
      #       idleTimeout = 600;
      #     };
      #     whenSleepingEnter = "standby";
      #     dimDisplay = {
      #       idleTimeout = 300;
      #     };
      #     powerProfile = "powerSaving";
      #     turnOffDisplay = {
      #       idleTimeout = 600;
      #     };
      #   };
      #   lowBattery = {
      #     whenLaptopLidClosed = "shutDown";
      #     powerProfile = "powerSaving";
      #   };
      #   batteryLevels = {
      #     criticalLevel = 3;
      #     lowLevel = 10;
      #     criticalAction = "shutDown";
      #   };
      # };

      kwin = {
        effects = {
          blur.enable = false;
          dimAdminMode.enable = false;
          wobblyWindows.enable = false;
          minimization.animation = "none";
          # minimization.animation = "magiclamp";
        };
        nightLight = {
          enable = true;
          location.latitude = "52";
          location.longitude = "13";
          mode = "location";
          temperature.night = 2700;
        };
        titlebarButtons = {
          left = ["more-window-actions"];
          right = ["keep-above-windows" "minimize" "maximize" "close"];
        };
        virtualDesktops = {
          number = 4;
          rows = 1;
          names = [
            "Desktop 1"
            "Desktop 2"
            "Desktop 3"
            "Desktop 4"
          ];
        };
      };

      shortcuts = {
        "org.kde.konsole.desktop"."_launch" = "Ctrl+Alt+T";
        ksmserver."Lock Session" = [
          "Screensaver"
          "Meta+Ctrl+Alt+L"
        ];
        kwin = {
          "Switch One Desktop to the Left" = "Ctrl+Alt+Left";
          "Switch One Desktop to the Right" = "Ctrl+Alt+Right";
          "Window Close" = "Alt+F4\tMeta+Q";
          "Kill Window" = "Meta+Ctrl+Esc\tCtrl+Alt+Esc";
          "Expose" = "Ctrl+F9\tMeta+A";
          "Window Maximize" = "Meta+PgUp\tMeta+Up";
          "Window Quick Tile Top" = "none";
          "Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left\tCtrl+Alt+Shift+Left";
          "Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right\tCtrl+Alt+Shift+Right";
          "Switch Window Down" = "Meta+J";
          "Switch Window Left" = "Meta+H";
          "Switch Window Right" = "Meta+L";
          "Switch Window Up" = "Meta+K";
        };
        mediacontrol.playpausemedia = "Media Play\tCtrl+Alt+D";
        plasmashell."manage activities" = "none";
        plasmashell."switch to next activity" = "Meta+Tab";
      };

      hotkeys.commands = {
        "reload-plasma" = {
          name = "Reload Plasma";
          key = "Meta+Shift+K";
          command = "${pkgs.systemd}/bin/systemctl --user restart plasma-plasmashell";
          logs.enabled = false;
        };
      };

      configFile = {
        baloofilerc."Basic Settings".Indexing-Enabled = false;
        kwinrc.org.kde.kdecoration2.ButtonsOnLeft = "SF";
        kwinrc.Desktops.Number = {
          value = 8;
          # Forces kde to not change this value (even through the settings app).
          immutable = true;
        };
        PlasmaDiscoverUpdates.Global.RequiredNotificationInterval = -1;
        plasmashellrc."Notification Messages".klipperClearHistoryAskAgain = false;
        ksmserverrc.General.loginMode = "emptySession";
        ksmserverrc.General.shutdownType = 2;
        kwinrc.MouseBindings.CommandActiveTitlebar2 = "Minimize";
        kwinrc.MouseBindings.CommandAllWheel = "Maximize/Restore";
        kwinrc.MouseBindings.CommandInactiveTitlebar2 = "Minimize";
        kwinrc.MouseBindings.CommandTitlebarWheel = "Previous/Next Desktop";
        kwinrc.Windows.DelayFocusInterval = 0;
        kwinrc.Windows.FocusPolicy = "FocusFollowsMouse";
        kwinrc.Windows.NextFocusPrefersMouse = true;
        kcminputrc.Mouse.XLbInptAccelProfileFlat = true;
        kded5rc.Module-device_automounter.autoload = false;
        kactivitymanagerdrc = {
          activities = {
            Default = "Default";
            Communication = "Communication";
          };
          activities-icons = {
            Default = "activities";
            Communication = "activities";
          };
          main.currentActivity = "Default";
        };
        kxkbrc.Layout = {
          Use = true;
          Options = "ctrl:nocaps,caps:ctrl_shifted_capslock,grp:win_space_toggle";
          ResetOldOptions = true;
          ShowLayoutIndicator = true;
          HighlightNonDefaultSettings = true;
        };
        "flameshot/flameshot.ini".General = {
          showDesktopNotification = false;
          showStartupLaunchMessage = false;
          autoCloseIdleDaemon = true;
          disabledTrayIcon = true;
          saveLastRegion = true;
        };
      };

      dataFile = {
        "dolphin/view_properties/global/.directory"."Dolphin"."SortRole" = "modificationtime";
        "dolphin/view_properties/global/.directory"."Dolphin"."ViewMode" = 1;
        "dolphin/view_properties/global/.directory"."Settings"."HiddenFilesShown" = true;
      };
    };
  };
}
