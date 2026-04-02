{ inputs, ... }:
{
  flake.modules.homeManager.emu-switch =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = [ inputs.self.modules.homeManager.mutableFiles ];
      home.packages = [
        pkgs.ryubing
        pkgs.azahar
      ];

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
