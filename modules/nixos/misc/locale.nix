{
  config,
  lib,
  ...
}: let
  cfg = config.local.misc.locale;
in {
  options.local.misc.locale = {
    enable = lib.mkEnableOption "Enable locale configuration";
    defaultLocale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "Set timezone to the closest country/region";
    };
    # TODO add later
    # extraLocales = lib.mkOption {
    #   type = lib.types.listOf lib.types.str;
    #   default = ["pt_BR.UTF-8"];
    # };
    timezone = lib.mkOption {
      type = lib.types.str;
      default = "America/Bahia";
      description = "Set timezone to the closest country/region";
    };
  };
  config = lib.mkIf cfg.enable {
    i18n = {
      defaultLocale = cfg.defaultLocale;
      extraLocaleSettings = {
        LC_TIME = lib.mkDefault "pt_BR.UTF-8";
      };
      supportedLocales = lib.mkDefault [
        "en_US.UTF-8/UTF-8"
        "pt_BR.UTF-8/UTF-8"
      ];
    };
    location.provider = "geoclue2";
    time.timeZone = cfg.timezone;
  };
}
