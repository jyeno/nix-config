{
  flake.modules.nixos.gaming-xonotic-server = {
    services.xonotic = {
      enable = true;
      settings = {
        port = 25598;
        hostname = "Nordeste do Sul (Gameplays)";
        sv_motd = "cabouse";
        #sv_public = 1;

        # configor cafe
        sv_public = 0;
        skill = 3;
        g_grappling_hook = 1;
      };
      prependConfig = ''
        exec ruleset-overkill.cfg
      '';
      appendConfig = ''
        bot_number 5
        g_powerups 0
        g_pickup_items 0

        sv_curl_defaulturl "http://dl.xonotic.fps.gratis/"
        sv_vote_gametype 1
        sv_weaponstats_file "http://www.xonotic.org/weaponbalance/"
      '';
    };
  };
}
