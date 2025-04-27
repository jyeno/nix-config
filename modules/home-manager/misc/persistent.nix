{
  config,
  lib,
  ...
}: let
  cfg = config.local.home.misc.persistent;
  symlinkDirs =
    builtins.map (dir: {
      directory = dir;
      method = "symlink";
    })
    cfg.directoriesSymlink;
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
    directoriesSymlink = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
      description = "list of home directories (symlink) to persist";
    };
    files = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
      description = "list of home files to persist";
    };
  };
  config = lib.mkIf cfg.enable {
    home.persistence."/persist/home/${config.home.username}" = {
      directories = cfg.directories ++ symlinkDirs;
      files = cfg.files;
      allowOther = true;
    };
  };
}
