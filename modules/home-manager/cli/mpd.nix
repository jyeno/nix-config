{
  config,
  lib,
  ...
}: let
  cfg = config.local.home.cli.mpd;
in {
  options.local.home.cli.mpd = {
    enable = lib.mkEnableOption "Enable MPD server";
    ncmpcpp = {
      enable = lib.mkEnableOption "Enable ncmpcpp util";
      bindings = lib.mkOption {
        type = lib.types.attrs;
        default = [
          {
            key = "j";
            command = "scroll_down";
          }
          {
            key = "k";
            command = "scroll_up";
          }
          {
            key = "J";
            command = ["select_item" "scroll_down"];
          }
          {
            key = "K";
            command = ["select_item" "scroll_up"];
          }
        ];
        description = "ncmpcpp bindings config";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    # TODO add more options
    services.mpd = {
      enable = true;
      musicDirectory = "${config.home.homeDirectory}/music";
      playlistDirectory = "${config.home.homeDirectory}/music/playlists";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
      '';
    };

    programs.ncmpcpp = {
      enable = cfg.ncmpcpp.enable;
      bindings = cfg.ncmpcpp.bindings;
    };
  };
}
