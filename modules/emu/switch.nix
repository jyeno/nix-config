{inputs, ...}: {
  # emu.switch = {
  #   enable = true;
  #   gameDirs = ["/home/games/switch"];
  #   resolutionScaling = 1440;
  #   antialiasing = "SmaaUltra";
  #   aspectRatio = "21:9";
  #   dramSize = 8;
  # };
  flake.modules.homeManager.emu-switch = {
    pkgs,
    config,
    ...
  }: let
    dramList = [4 6 8 12];
    resolutions = ["720/1080" "1440/2160" "2160/3240" "2880/4320"];
    aaList = ["None" "Fxaa" "SmaaLow" "SmaaMedium" "SmaaHigh" "SmaaUltra"];
    defaultRyujinxConfig = builtins.fromJSON (builtins.readFile ./ryujinxDefaultConfig.json);
    gameDirs = ["/home/${config.home.username}/switchGames/"]; # maybe leave empty /home/games/switch
    password = "ddcd34e2";
    resolutionScaling = 1080;
    antialiasing = "SmaaHigh";
    aspectRatio = "16:9";
    # type = with lib.types; addCheck int (i: builtins.elem i dramList);
    dramSize = 4;
  in {
    imports = with inputs.self.modules.homeManager; [mutableFiles];
    home.packages = [
      pkgs.ryubing
    ];
    xdg.configFile."Ryujinx/Config.json" = {
      # TODO change, use JSON only
      mutable = true;
      force = true;
      text =
        builtins.toJSON
        {
          res_scale =
            (pkgs.lib.lists.findFirstIndex (res: let
                splitRes = pkgs.lib.splitString "/" res;
              in
                builtins.elem (builtins.toString resolutionScaling) splitRes)
              0
              resolutions)
            + 1;
          aspect_ratio = "Fixed" + (pkgs.lib.replaceString ":" "x" aspectRatio);
          anti_aliasing = antialiasing;
          dram_size = pkgs.lib.lists.findFirstIndex (val: val == dramSize) 1 dramList;
          game_dirs = gameDirs;
          autoload_dirs = gameDirs;
          multiplayer_mode = 1;
          multiplayer_ldn_passphrase = "Ryujinx-" + password;
        };
    };

    xdg.configFile."Ryujinx/system/Profiles.json" = {
      force = true;
      mutable = true;
      text = builtins.toJSON {
        profiles = [
          {
            user_id = "00000000000000010000000000000000";
            name = config.home.username;
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
