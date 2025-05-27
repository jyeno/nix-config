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

    home.file.".local/share/konsole/${config.home.username}.profile".text = ''
      [General]
      Name=${config.home.username}
      Parent=FALLBACK/

      [Scrolling]
      HistorySize=10000
      ScrollFullPage=1
    '';
    #monitor settings, TODO improve
    home.file.".config/kwinoutputconfig.json".text = builtins.toJSON [
      {
        data = [
          {
            allowSdrSoftwareBrightness = true;
            autoRotation = "InTabletMode";
            brightness = 0.8;
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
            sdrGamutWideness = 0.5;
            transform = "Normal";
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

      hotkeys.commands."launch-ghostty" = {
        name = "Launch Ghostty";
        key = "Meta+Enter";
        command = "${pkgs.ghostty}";
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
            "org.kde.plasma.pager"
            # {
            #   pager.general = {
            #     showWindowOutlines = true;
            #     showApplicationIconsOnWindowOutlines = true;
            #     showOnlyCurrentScreen = true;
            #     navigationWrapsAround = true;
            #     displayedText = "desktopNumber";
            #     selectingCurrentVirtualDesktop = "doNothing";
            #   };
            # }
            {
              iconTasks = {
                launchers = [
                  "applications:org.kde.konsole.desktop"
                  "applications:steam.desktop"
                  "applications:io.github.kukuruzka165.materialgram.desktop"
                  "applications:chromium-browser.desktop"
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
      ];

      # powerdevil = lib.mkOptionals config.local.laptop {
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
          minimization.animation = "off";
          # minimization.animation = "magiclamp";
        };
        nightLight = {
          enable = false;
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
        # kwinrc.org.kde.kdecoration2.ButtonsOnLeft = "SF";
        kwinrc.Desktops.Number = {
          value = 4;
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
        kxkbrc.Layout = {
          Use = true;
          VariantList = "intl,workman-intl,colemak_dh";
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
        konsolerc = {
          MenuBar = "Disabled";
          "Desktop Entry".DefaultProfile = "${config.home.username}.profile";
          General.ConfigVersion = 1;
          KonsoleWindow.RemoveWindowTitleBarAndFrame = true;
          TabBar = {
            NewTabBehavior = "PutNewTabAfterCurrentTab";
            TabBarVisibility = "AlwaysHideTabBar";
          };
          UiSettings.ColorScheme = "";
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
