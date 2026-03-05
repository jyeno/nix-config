{
  flake.modules.nixos.locale =
    { lib, ... }:
    {
      i18n = {
        defaultLocale = lib.mkDefault "en_US.UTF-8";
        extraLocaleSettings = lib.mkDefault {
          LC_TIME = "pt_BR.UTF-8";
          LC_ADDRESS = "pt_BR.UTF-8";
          LC_IDENTIFICATION = "pt_BR.UTF-8";
          LC_MEASUREMENT = "pt_BR.UTF-8";
          LC_MONETARY = "pt_BR.UTF-8";
          LC_NAME = "pt_BR.UTF-8";
          LC_NUMERIC = "pt_BR.UTF-8";
          LC_PAPER = "pt_BR.UTF-8";
          LC_TELEPHONE = "pt_BR.UTF-8";
        };
        supportedLocales = lib.mkDefault [
          "en_US.UTF-8/UTF-8"
          "pt_BR.UTF-8/UTF-8"
        ];
      };
      location.provider = lib.mkDefault "geoclue2";
      time.timeZone = lib.mkDefault "America/Bahia";
    };
}
