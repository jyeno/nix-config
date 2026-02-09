{
  flake.modules.nixos.services-glance = {pkgs, ...}: {
    services.glance = {
      enable = true;
      settings.pages = [
        {
          columns = [
            {
              size = "small";
              widgets = [
                {
                  type = "calendar";
                }
                {
                  type = "rss";
                  limit = 10;
                  "collapse-after" = 3;
                  cache = "12h";
                  feeds = [
                    {
                      url = "https://selfh.st/rss";
                      title = "selfh.st";
                    }
                  ];
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "group";
                  widgets = [
                    {type = "hacker-news";}
                    {type = "lobsters";}
                  ];
                }
                {
                  type = "videos";
                  channels = [
                    "UCsBjURrPoezykLs9EqgamOA" # Fireship
                    "UCHnyfMqiRRG1u-2MsSQLbXA" # Veritasium
                    "UCR-DXc1voovS8nhAvccRZhg" # Jeff Geerling
                  ];
                }
              ];
            }
            {
              size = "small";
              widgets = [
                {
                  type = "markets";
                  markets = [
                    {
                      symbol = "SPY";
                      name = "S&P 500";
                    }
                    {
                      symbol = "BTC-USD";
                      name = "Bitcoin";
                    }
                    {
                      symbol = "XMR-USD";
                      name = "Monero";
                    }
                  ];
                }
              ];
            }
          ];
          name = "Home";
        }
      ];
    };
  };
}
