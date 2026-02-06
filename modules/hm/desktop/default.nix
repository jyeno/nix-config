{
  lib,
  localLib,
  ...
}: {
  imports = lib.attrsets.attrValues (localLib.discoverModules ./.);
  options.local.home.desktop = {
    keyboard = {
      xkb = {
        layout = lib.mkOption {
          type = lib.types.str;
          default = "us";
          example = "us";
        };
        variant = lib.mkOption {
          type = lib.types.str;
          default = "intl";
          example = "colemak_dh";
        };
        options = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "keyboard options modifier";
        };
      };
      repeatDelay = lib.mkOption {
        type = lib.types.int;
        default = 250;
        description = "keyboard repeat delay modifier";
      };
      repeatRate = lib.mkOption {
        type = lib.types.int;
        default = 25;
        description = "keyboard repeat rate modifier";
      };
      binds = lib.mkOption {
        # TODO create two types bind cmd and action, cmd runs programs, action may run a given action based on the compositor/wm
        # while cmd are only running given command, actions may vary based on the compositor, also it can be ignored if not properly configured
        # maybe add a check if all binds are set or treated at least
        type = with lib.types;
          listOf (submodule {
            options = {
              mod = lib.mkOption {
                type = lib.types.str;
                description = "Modifier key (e.g., 'Mod4', 'Mod1', 'Control', 'Shift')";
                example = "ALT";
              };
              keys = lib.mkOption {
                type = with lib.types; listOf str;
                description = "List of keys to bind";
                example = ["Return"];
              };
              cmd = lib.mkOption {
                type = lib.types.str;
                description = "Command to execute when the keybinding is triggered";
                example = "alacritty";
              };
              extras = lib.mkOption {
                type = with lib.types; nullOr attrs;
                default = null;
                description = "extra attrs, may be ignored";
              };
            };
          });
        default = [];
        description = "list of binds";
      };
    };
  };
}
