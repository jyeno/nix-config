{
  config,
  lib,
  ...
}: let
  cfg = config.local.home.misc.persistent;
  privateDirs =
    builtins.map (dir: {
      directory = dir;
      mode = "0700";
    })
    cfg.directoriesPrivate;
in {
  options.local.home.misc.persistent = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true; # use value from system impermanence enablement
      description = "Enable home persistent config";
    };
    directories = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
      description = "list of home directories to persist";
    };
    directoriesPrivate = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
      description = "list of home directories (private) to persist";
    };
    files = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
      description = "list of home files to persist";
    };
  };
  config = lib.mkIf cfg.enable {
    home.persistence."/persist" = {
      directories = cfg.directories ++ privateDirs;
      files = cfg.files;
    };
  };
}
