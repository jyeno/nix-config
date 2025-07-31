{
  config,
  lib,
  ...
}: let
  cfg = config.local.home.cli.newsboat;
in {
  options.local.home.cli.newsboat = {
    enable = lib.mkEnableOption "Enable newsboat configuration";
    extraConfig = lib.mkOption {
      type = lib.types.str;
      default = ''
        bind-key j next
        bind-key k prev
        bind-key l open
        bind-key h quit
        bind-key G end
        bind-key g home
        bind-key J next-feed
        bind-key K prev-feed
        bind-key j down article
        bind-key k up article
        bind-key J next article
        bind-key K prev article
      '';
      description = "newsboat extraConfig setting";
    };
    urls = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [];
      description = "urls for newsboat tracking"; # TODO improve explaining
    };
  };
  config = lib.mkIf cfg.enable {
    programs.newsboat = {
      enable = lib.mkDefault true;
      autoReload = true;
      extraConfig = cfg.extraConfig;
      # TODO substitute it for a parser of the urls given by the option
      urls = let
        url-tags = url: tags: {
          url = url;
          inherit tags;
        };
      in [
        (url-tags "https://fasterthanli.me/index.xml" ["how computer works" "rust" "blog"])
        (url-tags "https://matklad.github.io/feed.xml" ["zig" "blog"])
        (url-tags "https://begriffs.com/atom.xml" ["blog"])
        (url-tags "https://foonathan.net/feed.xml" ["blog"])
        (url-tags "https://deterministic.space/feed.xml" ["blog"])
        (url-tags "https://mariusbancila.ro/blog/feed/" ["blog"])
        (url-tags "https://maxliani.wordpress.com/feed.xml" ["blog"])
        (url-tags "https://blog.rust-lang.org/feed" ["rust" "blog"])
        (url-tags "https://www.sheshbabu.com/atom" ["rust" "blog"])
        (url-tags "https://blog.gabrielmajeri.ro/feed.xml" ["blog"])
        (url-tags "https://boats.gitlab.io/blog/index.xml" ["blog"])
        (url-tags "https://toscalix.com/feed" ["blog"])
        (url-tags "https://drewdevault.com/blog/index.xml" ["blog" "C"])
        (url-tags "https://h313.info/blog/feed.xml" ["blog"])
        (url-tags "https://humanreadablemag.com/feed.xml" ["blog"])
        (url-tags "https://readrust.net/all/feed.rss" ["blog" "rust" "group"])
        (url-tags "https://www.wezm.net/v2/rss.xml" ["rust"])
        (url-tags "https://lukesmith.xyz/rss.xml" ["blog"])
        (url-tags "https://blog.kodewerx.org/feeds/posts/default" ["blog" "rust"])
        (url-tags "https://planet.kde.org/global/atom.xml/" ["blog" "kde" "group"])
        (url-tags "https://blog.stephenmarz.com/feed" ["blog"])
        (url-tags "https://katcipis.github.io/index.xml" ["blog" "web"])
        (url-tags "https://osblog.stephenmarz.com/feed.rss" ["OS"])
        (url-tags "http://cliffle.com/rss.xml" ["rust" "blog"])
        (url-tags "https://tristanbrindle.com/feed.xml" ["cpp" "blog"])
        (url-tags "https://herbsutter.com/feed" ["cpp" "blog"])
        (url-tags "https://arne-mertz.de/feed" ["cpp" "blog"])
        (url-tags "https://blog.feabhas.com/feed" ["cpp" "blog"])
        (url-tags "https://feeds.fireside.fm/cppchat/rss" ["cpp" "podcast"])
        (url-tags "https://akrzemi1.wordpress.com/feed/" ["cpp" "blog"])
        (url-tags "https://isocpp.org/blog/rss/category/articles-books" ["cpp" "group" "blog"])
        (url-tags "https://isocpp.org/blog/rss/category/news" ["cpp" "group" "blog"])
        (url-tags "https://www.youtube.com/feeds/videos.xml?channel_id=UCSyG9ph5BJSmPRyzc_eGC4g" ["youtube" "libertarian"])
        (url-tags "https://www.orbit.fm/bookbytes/feed.rss" ["podcast"])
        (url-tags "http://feeds.feedburner.com/misesaudiobooks" ["podcast" "libertarian"])
        (url-tags "http://feeds.soundcloud.com/users/soundcloud:users:239787249/sounds.rss" ["podcast"])
        (url-tags "http://feeds.soundcloud.com/users/soundcloud:users:721404514/sounds.rss" ["podcast" "rust"])
        (url-tags "http://feeds.feedburner.com/ProgrammingThrowdown" ["podcast" "prog"])
        (url-tags "https://agilein3minut.es/archive/index.rss" ["podcast" "agile"])
        (url-tags "https://completedeveloperpodcast.com/feed/podcast/" ["podcast" "prog"])
        (url-tags "http://feeds.feedburner.com/CppWeekly" ["podcast" "cpp"])
        (url-tags "https://cppcast.libsyn.com/rss" ["podcast" "cpp"])
        (url-tags "https://anchor.fm/s/8d823ec/podcast/rss" ["podcast"])
        (url-tags "https://anchor.fm/s/34251ca8/podcast/rss" ["podcast" "monero"])
        (url-tags "https://getmonero.org/feed.xml" ["cryptocurrency" "monero"])
      ];
    };
  };
}
