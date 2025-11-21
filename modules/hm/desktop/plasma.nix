{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.home.desktop.plasma;
  username = config.home.username;
in {
  options.local.home.desktop.plasma = {
    enable = lib.mkEnableOption "Enable plasma configuration";
    konsole = {
      enable = lib.mkEnableOption "Enable konsole";
      removeTitleBarAndFrame = lib.mkEnableOption "Enable konsole";
      tabBarConfig = lib.mkOption {
        type = lib.types.attrs;
        default = {
          NewTabBehavior = "PutNewTabAfterCurrentTab";
          TabBarVisibility = "AlwaysHideTabBar";
        };
        description = "konsole tabbar settings";
      };
      profileConfig = lib.mkOption {
        type = lib.types.attrs;
        default = {
          Scrolling = {
            HistorySize = 100000;
            ScrollFullPage = 1;
          };
        };
        description = "konsole default user settings";
      };
    };
    workspace = lib.mkOption {
      type = lib.types.attrs;
      default = {
        clickItemTo = "select";
        colorScheme = "BreezeDark";
        lookAndFeel = "org.kde.breezedark.desktop";
        iconTheme = "breeze-dark";
        theme = "breeze-dark";
        cursor = {
          theme = "breeze_cursors";
          size = 24;
        };
      };
      description = "plasma workspace settings";
    };
    powerdevil = lib.mkOption {
      type = lib.types.attrs;
      default = {
        AC = {
          autoSuspend = {
            action = "nothing";
          };
          dimDisplay.enable = true;
          powerProfile = "performance";
          turnOffDisplay.idleTimeout = "never";
        };
        battery = {
          autoSuspend = {
            action = "sleep";
            idleTimeout = 600;
          };
          whenSleepingEnter = "standby";
          dimDisplay = {
            idleTimeout = 300;
          };
          powerProfile = "powerSaving";
          turnOffDisplay = {
            idleTimeout = 600;
          };
        };
        lowBattery = {
          whenLaptopLidClosed = "shutDown";
          powerProfile = "powerSaving";
        };
        batteryLevels = {
          criticalLevel = 3;
          lowLevel = 10;
          criticalAction = "shutDown";
        };
      };
      description = "powerdevil settings";
    };
    hotkeys = lib.mkOption {
      type = lib.types.attrs;
      default = {
        "launch-ghostty" = {
          name = "Launch Ghostty";
          key = "Meta+Return";
          command = "${lib.getExe pkgs.ghostty}";
        };
        "reload-plasma" = {
          name = "Reload Plasma";
          key = "Meta+Shift+K";
          command = "${pkgs.systemd}/bin/systemctl --user restart plasma-plasmashell";
          logs.enabled = false;
        };
      };
      description = "hotkey commands settings";
    };
    panels = lib.mkOption {
      type = with lib.types; listOf attrs;
      default = [
        {
          location = "left";
          hiding = "autohide";
          height = 50;
          floating = false;
          widgets = [
            {
              kickoff = {
                sortAlphabetically = true;
                icon = "nix-snowflake-white";
              };
            }
            {
              iconTasks = {
                launchers = [
                  "applications:com.mitchellh.ghostty.desktop"
                  "applications:steam.desktop"
                  "applications:io.github.kukuruzka165.materialgram.desktop"
                  "applications:org.qutebrowser.qutebrowser.desktop"
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
                  # showSeconds = "always";
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
        }
      ];
      description = "plasma panels settings";
    };
    window-rules = lib.mkOption {
      type = with lib.types; listOf attrs;
      default = [
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
      ];
      description = "kwin window rules list";
    };
    kwin = {
      effects = lib.mkOption {
        type = lib.types.attrs;
        default = {
          blur.enable = false;
          dimAdminMode.enable = false;
          wobblyWindows.enable = false;
          minimization.animation = "off";
        };
        description = "effect settings";
      };
      nightLight = lib.mkOption {
        type = lib.types.attrs;
        default = {
          enable = true;
          mode = "times";
          temperature.night = 2700;
          transitionTime = 30;
          time = {
            morning = "06:30";
            evening = "19:30";
          };
        };
        description = "night light settings";
      };
      titlebarButtons = lib.mkOption {
        type = lib.types.attrs;
        default = {
          left = ["more-window-actions"];
          right = ["keep-above-windows" "minimize" "maximize" "close"];
        };
        description = "title bar buttons settings";
      };
      tiling = lib.mkOption {
        type = lib.types.attrs;
        default = {
          padding = 5;
          layout = {
            id = "cf5c25c2-4217-4193-add6-b5971cb543f2";
            tiles = {
              layoutDirection = "horizontal";
              tiles = [
                {
                  width = 0.5;
                }
                {
                  layoutDirection = "vertical";
                  tiles = [
                    {
                      height = 0.5;
                    }
                    {
                      height = 0.5;
                    }
                  ];
                  width = 0.5;
                }
              ];
            };
          };
        };
        description = "tiling settings";
      };
      virtualDesktops = lib.mkOption {
        type = with lib.types; listOf str;
        default = ["Desktop 1" "Desktop 2" "Desktop 3" "Desktop 4"];
        description = "list of virtual desktop names";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    programs.konsole = {
      enable = cfg.konsole.enable;
      defaultProfile = "${username}";
      profiles."${username}".extraConfig = cfg.konsole.profileConfig;
      extraConfig = {
        KonsoleWindow.RemoveWindowTitleBarAndFrame = cfg.RemoveWindowTitleBarAndFrame;
        TabBar = cfg.konsole.tabBarConfig;
      };
    };

    programs.plasma = {
      enable = true;
      overrideConfig = lib.mkDefault true;
      immutableByDefault = lib.mkDefault true;
      inherit (cfg) workspace panels window-rules powerdevil;
      kscreenlocker.autoLock = lib.mkDefault true;
      hotkeys.commands = cfg.hotkeys;

      kwin = {
        inherit (cfg.kwin) effects nightLight titlebarButtons tiling;
        virtualDesktops = {
          number = builtins.length cfg.kwin.virtualDesktops;
          rows = 1;
          names = cfg.kwin.virtualDesktops;
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
        plasmashell = {
          "manage activities" = "none";
          "switch to next activity" = "Meta+Tab";
        };
      };

      input = {
        keyboard = {
          layouts = [
            {
              layout = "us";
              variant = "intl";
            }
            {
              displayName = "wk";
              layout = "us";
              variant = "workman-intl";
            }
            {
              displayName = "cl-dh";
              layout = "us";
              variant = "colemak_dh";
            }
          ];
          options = ["ctrl:nocaps" "caps:ctrl_shifted_capslock" "grp:win_space_toggle"];
          repeatDelay = 250;
          repeatRate = 40;
        };
        mice = [
          {
            acceleration = 0.5;
            vendorId = "1d57";
            productId = "fa65";
            name = "LXDDZ 2.4G 8K HS Receiver ";
            accelerationProfile = "none";
            scrollSpeed = 1;
            naturalScroll = false;
            enable = true;
          }
        ];
      };

      configFile = lib.mkDefault {
        baloofilerc."Basic Settings".Indexing-Enabled = false;
        # kwinrc.org.kde.kdecoration2.ButtonsOnLeft = "SF";
        PlasmaDiscoverUpdates.Global.RequiredNotificationInterval = -1;
        plasmashellrc."Notification Messages".klipperClearHistoryAskAgain = false;
        ksmserverrc.General = {
          loginMode = "emptySession";
          shutdownType = 2;
        };
        kwinrc = {
          Desktops.Number = lib.mkDefault {
            value = builtins.length cfg.kwin.virtualDesktops;
            immutable = true;
          };
          MouseBindings = {
            CommandActiveTitlebar2 = "Minimize";
            CommandAllWheel = "Maximize/Restore";
            CommandInactiveTitlebar2 = "Minimize";
            CommandTitlebarWheel = "Previous/Next Desktop";
          };
          Windows = {
            DelayFocusInterval = 0;
            FocusPolicy = "FocusFollowsMouse";
            NextFocusPrefersMouse = true;
          };
        };
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
        spectaclerc = {
          General = {
            clipboardGroup = "PostScreenshotCopyImage";
            launchAction = "UseLastUsedCapturemode";
            rememberSelectionRect = "Always";
          };
          GuiConfig = {
            captureMode = 0;
            includeDecorations = false;
          };
          ImageSave = {
            imageCompressionQuality = 100;
            translatedScreenshotsFolder = "Screenshots";
          };
          VideoSave.translatedScreencastsFolder = "Screencasts";
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
        "dolphin/view_properties/global/.directory" = {
          "Dolphin"."SortRole" = "modificationtime";
          "Dolphin"."ViewMode" = 1;
          "Settings"."HiddenFilesShown" = true;
        };
      };
    };
  };
}
