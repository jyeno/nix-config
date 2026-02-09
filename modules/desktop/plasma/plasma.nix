{inputs, ...}: {
  flake.modules.nixos.desktop-plasma = {
    # TODO check bug https://github.com/nix-community/stylix/issues/1092
    services.desktopManager.plasma6.enable = true;

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  flake.modules.homeManager.desktop-plasma = {
    pkgs,
    config,
    lib,
    ...
  }: let
    username = config.home.username;
    userBinds = builtins.listToAttrs (
      builtins.map (
        bind: let
          prefix =
            if bind.mod == ""
            then ""
            else "${bind.mod}+";
          getCmdName = bind:
            if lib.hasAttr "description" bind.extras
            then bind.extras.description
            else builtins.baseNameOf (builtins.head (builtins.split " " bind.cmd));
        in {
          name = "${bind.mod}-${builtins.concatStringsSep "-" bind.keys}";
          value = {
            name = "Run ${getCmdName bind}";
            key = "${prefix}${builtins.concatStringsSep "+" bind.keys}";
            command = bind.cmd;
          };
        }
      )
      config.systemConstants.keyboard.binds
    );
  in {
    imports = [
      inputs.self.modules.homeManager.plasma-manager
    ];
    programs.konsole = {
      enable = true; # or maybe not
      defaultProfile = "${username}";
      profiles."${username}".extraConfig = {
        Scrolling = {
          HistorySize = 100000;
          ScrollFullPage = 1;
        };
      };
      extraConfig = {
        KonsoleWindow.RemoveWindowTitleBarAndFrame = true;
        TabBar = {
          NewTabBehavior = "PutNewTabAfterCurrentTab";
          TabBarVisibility = "AlwaysHideTabBar";
        };
      };
    };

    programs.plasma = {
      enable = true;
      overrideConfig = true;
      immutableByDefault = true;
      workspace = {
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
      panels = [
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
      powerdevil = {
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
      kscreenlocker.autoLock = true;
      hotkeys.commands = userBinds;

      kwin = {
        effects = {
          blur.enable = false;
          dimAdminMode.enable = false;
          wobblyWindows.enable = false;
          minimization.animation = "off";
        };
        nightLight = {
          enable = true;
          mode = "times";
          temperature.night = 2700;
          transitionTime = 30;
          time = {
            morning = "06:30";
            evening = "19:30";
          };
        };
        titlebarButtons = {
          left = ["more-window-actions"];
          right = ["keep-above-windows" "minimize" "maximize" "close"];
        };
        virtualDesktops = {
          number = 4;
          rows = 1;
          names = ["Desktop 1" "Desktop 2" "Desktop 3" "Desktop 4"];
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
        keyboard = let
          keyboard = config.systemConstants.keyboard;
        in {
          inherit (keyboard) repeatDelay repeatRate;

          layouts = let
            layouts = lib.splitString "," keyboard.xkb.layout;
            variants = lib.splitString "," keyboard.xkb.variant;
          in
            lib.zipListsWith (l: v: {
              layout = l;
              variant = v;
            })
            layouts
            variants;
          options = lib.splitString "," config.systemConstants.keyboard.xkb.options;
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

      configFile = {
        baloofilerc."Basic Settings".Indexing-Enabled = false;
        # kwinrc.org.kde.kdecoration2.ButtonsOnLeft = "SF";
        PlasmaDiscoverUpdates.Global.RequiredNotificationInterval = -1;
        plasmashellrc."Notification Messages".klipperClearHistoryAskAgain = false;
        ksmserverrc.General = {
          loginMode = "emptySession";
          shutdownType = 2;
        };
        kwinrc = {
          Desktops.Number = {
            value = 4;
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
  };
}
