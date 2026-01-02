{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.local.home.emu.switch;
  dramList = [4 6 8 12];
  resolutions = ["720/1080" "1440/2160" "2160/3240" "2880/4320"];
  aaList = ["None" "Fxaa" "SmaaLow" "SmaaMedium" "SmaaHigh" "SmaaUltra"];
  defaultRyujinxConfig =
    builtins.readFile ../../extras/desktop/ryujinxDefaultConfig.json
    |> builtins.fromJSON;
in {
  options.local.home.emu.switch = {
    enable = lib.mkEnableOption "Enable ryugames configuration";
    gameDirs = lib.mkOption {
      type = with lib.types; listOf str;
      default = [config.home.xdg."switchGames/"]; # maybe leave empty /home/games/switch
      description = "dir where switch games are at";
    };
    multiplayer = {
      enable = lib.mkEnableOption "Enable multiplayer configuration" // {default = true;};
      username = lib.mkOption {
        type = lib.types.str;
        default = config.home.username;
        description = "profile name";
      };
      password = lib.mkOption {
        type = lib.types.strMatching "[a-fA-F0-9]{8}";
        default = "ddcd34e2";
        description = "8 hexadecimal number password, it is automatically prepended with Ryujinx-";
      };
    };
    resolutionScaling = lib.mkOption {
      type = lib.types.int;
      default = 1080;
      description = "available values: 720, 1080, 1440, 2160, 3240, 2880, 4320 (last 2 not recommended)";
    };
    # TODO test
    antialiasing = lib.mkOption {
      type = with lib.types; addCheck str (s: builtins.elem s aaList);
      default = "SmaaHigh";
      description = "FXAA will blur most of the image (better performance), SMAA will attempt to find jagged edges and smooth them out";
    };
    aspectRatio = lib.mkOption {
      type = with lib.types; addCheck str (s: builtins.elem s ["4:3" "16:9" "16:10" "21:9" "32:9"]);
      default = "16:9";
      description = "aspect ratio for the game";
      # TODO stretch to fit window
    };
    dramSize = lib.mkOption {
      type = with lib.types; addCheck int (i: builtins.elem i dramList);
      default = 4;
      description = "set dram size, availables: 4, 6, 8, 12";
    };
    extraConfig = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "extra settings like input_config, logging and such";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.ryubing
    ];
    xdg.configFile."Ryujinx/Config.json" = {
      mutable = true;
      force = true;
      text =
        builtins.toJSON
        (lib.recursiveUpdate defaultRyujinxConfig
          {
            res_scale =
              (lib.lists.findFirstIndex (res: let
                  splitRes = lib.splitString "/" res;
                in
                  builtins.elem cfg.resolutionScaling splitRes)
                0
                resolutions)
              + 1;
            aspect_ratio = "Fixed" + (lib.replaceString ":" "x" cfg.aspectRatio);
            anti_aliasing = cfg.antialiasing;
            dram_size = lib.lists.findFirstIndex (val: val == cfg.dramSize) 1 dramList;
            game_dirs = cfg.gameDirs;
            autoload_dirs = cfg.gameDirs;
            multiplayer_mode =
              if cfg.multiplayer.enable
              then 1
              else 0;
            multiplayer_ldn_passphrase = "Ryujinx-" + cfg.multiplayer.password;
          }
          // cfg.extraConfig);
    };

    xdg.configFile."Ryujinx/system/Profiles.json" = {
      force = true;
      mutable = true;
      text = builtins.toJSON {
        profiles = [
          {
            user_id = "00000000000000010000000000000000";
            name = cfg.multiplayer.username;
            account_state = "Open";
            online_play_state = "Closed";
            last_modified_timestamp = 1767045505;
          }
        ];
        last_opened = "00000000000000010000000000000000";
      };
    };
  };
}
