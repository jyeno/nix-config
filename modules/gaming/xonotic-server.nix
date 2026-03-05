{
  flake.modules.nixos.gaming-xonotic-server =
    { lib, ... }:
    {
      services.xonotic = {
        enable = true;
        settings = lib.mkDefault {
          port = 25598;
          hostname = "Nordeste do Sul (Gameplays)";
          sv_motd = "cabouse";
          sv_public = 0;
          skill = 5;
          g_grappling_hook = 1;
        };
        prependConfig = lib.mkDefault ''
          exec ruleset-overkill.cfg
        '';
        appendConfig = lib.mkDefault ''
          bot_number 6
          g_powerups 0
          g_pickup_items 0

          sv_curl_defaulturl "http://dl.xonotic.fps.gratis/"
          sv_vote_gametype 1
          sv_weaponstats_file "http://www.xonotic.org/weaponbalance/"
        '';
      };
    };
}
