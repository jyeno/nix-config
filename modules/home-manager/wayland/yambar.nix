{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.home.wayland.yambar;
in {
  options.local.home.wayland.yambar = {
    enable = lib.mkEnableOption "Enable yambar configuration";
  };
  config = lib.mkIf cfg.enable {
    #TODO add more options
    systemd.user.services.yambar = {
      Unit = {
        Description = "yambar service.";
        Documentation = "https://codeberg.org/dnkl/yambar";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session-pre.target" "sound.target"];
      };
      Install.WantedBy = ["graphical-session.target"];
      Service = {
        ExecStart = "${lib.getExe pkgs.yambar}";
        Restart = "on-failure";
      };
    };

    programs.yambar = {
      enable = true;
      settings = {
        bar = let
          # Separator to print between modules
          module-sep = {label.content.string.text = "|";};

          # Shortcut for writing basic string output
          basic-string = text: {
            string = {
              margin = 5;
              inherit text;
            };
          };

          # Shortcut for writing awesome string output with foreground
          awesome-string-f = text: foreground: {
            string = {
              margin = 10;
              font = "*awesome";
              inherit text;
              inherit foreground;
            };
          };

          # Shortcut for writing awesome string output with chosen foreground
          awesome-string = text: awesome-string-f text "ffffff66";

          # Shortcut for empty content
          empty = {empty = {};};

          mpc = lib.getExe pkgs.mpc-cli;
          riverctl = lib.getExe' pkgs.river "riverctl";
          wpctl = lib.getExe' pkgs.wireplumber "wpctl";
          iwctl = lib.getExe' pkgs.iwd "iwctl";
          cal = lib.getExe' pkgs.util-linux "cal";
          less = lib.getExe pkgs.less;
          foot = lib.getExe pkgs.foot;
          btop = lib.getExe pkgs.btop;
          bash = lib.getExe pkgs.bash;
          ncmpcpp = lib.getExe pkgs.ncmpcpp;
        in {
          location = "bottom";
          height = 40;
          background = "333333ff";

          left = [
            {
              river = let
                on-click = {
                  left = "${riverctl} set-focused-tags $((1 << ({id} - 1)))";
                  right = "${riverctl} toggle-focused-tags $((1 << ({id} - 1)))";
                };
                tag-default = name: lib.recursiveUpdate (basic-string "${name}") {string = {inherit on-click;};};
                tag-focused = name:
                  lib.recursiveUpdate (basic-string "${name}") {
                    string = {
                      deco.background.color = "666666ff";
                      inherit on-click;
                    };
                  };
                tag-urgent = name:
                  lib.recursiveUpdate (basic-string "${name}") {
                    string = {
                      deco.background.color = "ff4444ff";
                      inherit on-click;
                    };
                  };
                per-special-tag = hook: {
                  "id == 10" = hook "w";
                  "id == 11" = hook "e";
                  "id == 12" = hook "d";
                  "id == 13" = hook "n";
                  "id == 14" = hook "m";
                };
              in {
                content.map = {
                  default.map = {
                    default = tag-default "{id}";
                    conditions = per-special-tag tag-default;
                  };
                  conditions = {
                    "~occupied && ~focused" = empty;
                    urgent.map = {
                      default = tag-urgent "{id}";
                      conditions = per-special-tag tag-urgent;
                    };
                    focused.map = {
                      default = tag-focused "{id}";
                      conditions = per-special-tag tag-focused;
                    };
                  };
                };
              };
            }
          ];

          center = [
            {
              mpd = {
                host = "localhost";
                port = 6600;
                content.map = {
                  default = empty;
                  conditions = {
                    "state != \"offline\"".map = {
                      conditions = {
                        "state == \"playing\"" = awesome-string-f "{artist} - {title}  " "ffa0a0ff";
                        "state == \"paused\"" = awesome-string "{artist} - {title}  ";
                        "state == \"stopped\"" = empty;
                      };
                      on-click = {
                        left = "${mpc} toggle";
                        right = "${foot} -a float ${ncmpcpp}";
                      };
                    };
                  };
                };
              };
            }
          ];

          right = [
            # TODO create a news section, that opens up newsboat
            {
              battery = {
                name = "BAT0";
                content.map = {
                  default = awesome-string-f "    {capacity}%" "00ff00ff";
                  conditions = {
                    "state == \"discharging\"" = awesome-string-f "    {capacity}%" "ffa0a0ff";
                    "state == \"charging\"" = awesome-string-f "    {capacity}%" "00ff00ff";
                    "state == \"unknown\"" = empty;
                  };
                };
              };
            }

            module-sep

            {
              pipewire.content.map.conditions = {
                "type == \"sink\"".map = {
                  conditions = {
                    muted = awesome-string "   {cubic_volume}";
                    "~muted" = awesome-string "   {cubic_volume}";
                  };
                  on-click = {
                    left = "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
                    right = "${lib.getExe pkgs.pavucontrol}";
                  };
                };
              };
            }

            module-sep

            {
              cpu.content.map = {
                conditions = {
                  "id < 0" = awesome-string "   {cpu}%";
                };
                on-click = {
                  left = "${foot} -a float ${btop}";
                };
              };
            }

            module-sep

            {
              mem = {
                poll-interval = 2500;
                content = awesome-string "    {percent_used}%";
              };
            }

            module-sep

            {
              network.content.map = {
                default = empty;
                conditions = {
                  "name == wlan0".map = {
                    default = lib.recursiveUpdate (awesome-string-f "" "ffffff66") {string.on-click.left = "${foot} -a float ${iwctl}";};
                    conditions = {
                      "state == \"down\"" = awesome-string-f "" "ff0000ff";
                      "state == \"up\"".map = {
                        default = awesome-string "";
                        conditions = {
                          "ipv4 == \"\"" = awesome-string-f "" "ffffff66";
                        };
                      };
                    };
                  };
                };
              };
            }

            module-sep

            {
              clock = {
                date-format = "%a %m/%d";
                time-format = "%H:%M:%S";
                content = lib.recursiveUpdate (basic-string "{date}  {time}") {string.on-click.left = "${foot} -a float ${bash} -c '${cal} -3 --color=always | ${less} -R'";};
              };
            }
          ];
        };
      };
    };
  };
}
