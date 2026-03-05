{
  flake.modules.homeManager.cli-pass =
    { pkgs, ... }:
    {
      programs = {
        browserpass = {
          enable = true;
          browsers = [
            "firefox"
            "chromium"
          ];
        };
        password-store = {
          enable = true;
          package = pkgs.pass.withExtensions (exts: [
            exts.pass-otp
            exts.pass-file
            exts.pass-audit
            exts.pass-update
            exts.pass-import
          ]);
        };
      };
      services.pass-secret-service.enable = true;
    };
}
