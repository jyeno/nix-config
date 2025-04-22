{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.local.home.desktop.firefox;
in {
  options.local.home.desktop.firefox = {
    enable = lib.mkEnableOption "Enable firefox configuration";
  };
  config = lib.mkIf cfg.enable {
    #TODO add user options
    programs.firefox = {
      enable = true;
      # package = (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true;}) {});
      profiles.jyeno = {
        bookmarks = {};
        # TODO figure out why there are errors when calling the inputs.firefox-addons
        # extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
        #   ublock-origin
        #   augmented-steam
        #   sidebery
        #   browserpass
        # ];
        search.engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };
          "Nix Options" = {
            definedAliases = ["@no"];
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };
        };
        settings = {
          "app.shield.optoutstudies.enabled" = false;
          "app.normandy.enabled" = false;
          "app.normandy.api_url" = "";

          "beacon.enabled" = false;

          "browser.startup.homepage" = "https://start.duckduckgo.com";
          "browser.search.separatePrivateDefault.ui.enabled" = true;
          "browser.urlbar.update2.engineAliasRefresh" = true;
          "browser.search.suggest.enabled" = false;
          "browser.urlbar.suggest.quicksuggest.sponsored" = false;
          "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
          "browser.formfill.enable" = false;
          "browser.privatebrowsing.forceMediaMemoryCache" = true;
          "browser.sessionstore.interval" = 60000;
          "browser.download.start_downloads_in_tmp_dir" = true;
          "browser.helperApps.deleteTempFileOnExit" = true;
          "browser.uitour.enabled" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.ping-centre.telemetry" = false;
          "browser.contentblocking.category" = "strict";
          "browser.download.animateNotifications" = false;
          "browser.download.always_ask_before_handling_new_types" = true;
          "browser.download.manager.addToRecentDocs" = false;
          "browser.send_pings" = false;
          "browser.sessionstore.privacy_level" = 2;
          "browser.safebrowsing.downloads.remote.enabled" = false;
          "browser.pocket.enabled" = false;
          "browser.xul.error_pages.expert_bad_cert" = true;
          "browser.download.open_pdf_attachments_inline" = true;
          "browser.bookmarks.openInTabClosesMenu" = false;
          "browser.menu.showViewImageInfo" = true;
          "browser.cache.jsbc_compression_level" = 3;

          "cookiebanners.service.mode" = 1;
          "cookiebanners.service.mode.privateBrowsing" = 1;

          "content.notify.interval" = 100000;

          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;

          "dom.enable_web_task_scheduling" = true;
          "dom.event.clipboardevents.enabled" = true;
          "dom.security.https_first" = true;
          "dom.security.https_first_schemeless" = true;
          "dom.security.sanitizer.enabled" = true;

          "extensions.postDownloadThirdPartyPrompt" = false;
          "extensions.pocket.enabled" = false;

          "full-screen-api.transition-duration.enter" = "0 0";
          "full-screen-api.transition-duration.leave" = "0 0";
          "full-screen-api.warning.delay" = -1;
          "full-screen-api.warning.timeout" = 0;

          "fission.autostart" = true;

          "findbar.highlightAll" = true;

          "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";

          "gfx.canvas.accelerated.cache-items" = 4096;
          "gfx.canvas.accelerated.cache-size" = 512;
          "gfx.content.skia-font-cache-size" = 20;
          "gfx.webrender.all" = true;

          "image.mem.decode_bytes_at_a_time" = 32768;

          "layout.css.grid-template-masonry-value.enabled" = true;
          "layout.css.has-selector.enabled" = true;
          "layout.word_select.eat_space_to_next_word" = false;

          "loop.enabled" = false;

          "media.memory_cache_max_size" = 65536;
          "media.cache_readahead_limit" = 7200;
          "media.cache_resume_threshold" = 3600;
          "media.navigator.enabled" = false;
          "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
          "media.peerconnection.ice.default_address_only" = true;

          "network.cookie.cookiehardware-video-decoding,enabled" = true;
          "network.IDN_show_punycode" = true;
          "network.http.referer.XOriginTrimmingPolicy" = 2;
          "network.prefetch-next" = false;
          "network.predictor.enabled" = false;
          "network.cookie.sameSite.noneRequiresSecure" = true;
          "network.http.max-connections" = 1800;
          "network.http.max-persistent-connections-per-server" = 10;
          "network.http.max-urgent-start-excessive-connections-per-host" = 5;
          "network.http.pacing.requests.enabled" = false;
          "network.dns.disablePrefetch" = true;
          "network.dnsCacheExpiration" = 3600;
          "network.dns.max_high_priority_threads" = 8;
          "network.ssl_tokens_cache_capacity" = 10240;

          "permissions.default.desktop-notification" = 2;
          "permissions.default.geo" = 2;
          "permissions.manager.defaultsUrl" = "";

          "pdfjs.enableScripting" = false;

          "privacy.trackingprotection.fingerprinting.enable" = true;
          "privacy.trackingprotection.cryptomining.enable" = true;
          "privacy.trackingprotection.enable" = true;
          "privacy.history.custom" = true;
          "privacy.userContext.ui.enabled" = true;

          "reader.parse-on-load.enabled" = false;
          "reader.parse-on-load.force-enabled" = false;

          "security.dialog_enable_delay" = false;
          "security.OCSP.enabled" = 0;
          "security.remote_settings.crlite_filters.enabled" = true;
          "security.pki.crlite_mode" = 2;
          "security.ssl.treat_unsafe_negotiation_as_broken" = true;
          "security.tls.enable_0rtt_data" = false;
          "security.insecure_connection_text.enabled" = true;
          "security.insecure_connection_text.pbmode.enabled" = true;
          "security.mixed_content.block_display_content" = true;
          "security.mixed_content.upgrade_display_content" = true;
          "security.mixed_content.upgrade_display_content.image" = true;

          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.server" = "data:,";
          "toolkit.telemetry.coverage.opt-out" = true;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.coverage.opt-out" = true;
          "toolkit.coverage.endpoint.base" = "";

          "urlclassifier.trackingSkipURLs" = "*.reddit.com, *.twitter.com, *.twimg.com, *.tiktok.com";
          "urlclassifier.features.socialtracking.skipURLs" = "*.instagram.com, *.twitter.com, *.twimg.com";

          "webgl.disabled" = false;

          "webchannel.allowObject.urlWhitelist" = "";

          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "widget.use-xdg-desktop-portal.mime-handler" = 1;
        };
      };
    };

    xdg.mimeApps.defaultApplications = {
      "text/html" = ["firefox.desktop"];
      "text/xml" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
    };
  };
}
