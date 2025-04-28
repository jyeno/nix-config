{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.home.wayland.ashell;
in {
  options.local.home.wayland.ashell = {
    enable = lib.mkEnableOption "Enable ashell configuration";
    config = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "ashell config settings";
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.user.services.ashell = {
      Unit = {
        Description = "ashell service.";
        Documentation = "https://github.com/MalpenZibo/ashell";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target" "sound.target"];
        ConditionEnvironment = ["HYPRLAND_INSTANCE_SIGNATURE"];
      };
      Install.WantedBy = ["graphical-session.target"];
      Service = {
        ExecStart = "${lib.getExe pkgs.ashell}";
        Restart = "on-failure";
      };
    };

    xdg.configFile."ashell/config.yml".source = lib.mkIf (cfg.config != {}) ((pkgs.formats.yaml {}).generate "ashell-config" cfg.config);
  };
}
