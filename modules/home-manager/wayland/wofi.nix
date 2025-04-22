{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.home.wayland.wofi;
in {
  options.local.home.wayland.wofi = {
    enable = lib.mkEnableOption "Enable wofi configuration";
  };
  config = lib.mkIf cfg.enable {
    # TODO add more options
    programs.wofi = {
      enable = true;
      package = pkgs.wofi.overrideAttrs (oa: {
        patches =
          (oa.patches or [])
          ++ [
            ./wofi-run-shell.patch # Fix for https://todo.sr.ht/~scoopta/wofi/174
          ];
      });
      settings = {
        image_size = 48;
        columns = 3;
        allow_images = true;
        insensitive = true;
        run-always_parse_args = true;
        run-cache_file = "/dev/null";
        run-exec_search = true;
        matching = "multi-contains";
      };
    };

    # home.packages = let
    #   inherit (config.programs.password-store) package enable;
    # in
    #   lib.optional enable (pkgs.pass-wofi.override {pass = package;});
  };
}
