{inputs, ...}: {
  # TODO add inputs (maybe add overlay?)
  flake.modules.homeManager.desktop-firefox = {
    pkgs,
    config,
    ...
  }: {
    programs.firefox = {
      enable = true;
      # package = (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true;}) {});
      profiles."${config.home.username}" = {
        bookmarks = {};
        extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          ublock-origin
          augmented-steam
          sidebery
          browserpass
        ];
        search = {
          force = true;
          engines = {
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
        };
        settings = {
          app = {
            shield.optoutstudies.enabled = false;
            normandy = {
              enabled = false;
              api_url = "";
            };
          };

          beacon.enabled = false;

          browser = {
            startup.homepage = "https://start.duckduckgo.com";
            search = {
              separatePrivateDefault.ui.enabled = true;
              suggest.enabled = false;
            };
            urlbar = {
              update2.engineAliasRefresh = true;
              suggest.quicksuggest = {
                sponsored = false;
                nonsponsored = false;
              };
            };
            formfill.enable = false;
            privatebrowsing.forceMediaMemoryCache = true;
            sessionstore.interval = 60000;
            download.start_downloads_in_tmp_dir = true;
            helperApps.deleteTempFileOnExit = true;
            uitour.enabled = false;
            activity-stream = {
              feeds = {
                telemetry = false;
                topsites = false;
                section.topstories = false;
              };
              showSponsoredTopSites = false;
              telemetry = false;
            };
            ping-centre.telemetry = false;
            contentblocking.category = "strict";
            download = {
              animateNotifications = false;
              always_ask_before_handling_new_types = true;
              manager.addToRecentDocs = false;
              open_pdf_attachments_inline = true;
            };
            send_pings = false;
            sessionstore.privacy_level = 2;
            safebrowsing.downloads.remote.enabled = false;
            pocket.enabled = false;
            xul.error_pages.expert_bad_cert = true;
            bookmarks.openInTabClosesMenu = false;
            menu.showViewImageInfo = true;
            cache.jsbc_compression_level = 3;
          };

          cookiebanners.service = {
            mode = 1;
            privateBrowsing = 1;
          };

          content.notify.interval = 100000;

          datareporting = {
            policy.dataSubmissionEnabled = false;
            healthreport.uploadEnabled = false;
          };

          dom = {
            enable_web_task_scheduling = true;
            event.clipboardevents.enabled = true;
            security = {
              https_first = true;
              https_first_schemeless = true;
              sanitizer.enabled = true;
            };
          };

          extensions = {
            postDownloadThirdPartyPrompt = false;
            pocket.enabled = false;
          };

          full-screen-api = {
            transition-duration = {
              enter = "0 0";
              leave = "0 0";
            };
            warning = {
              delay = -1;
              timeout = 0;
            };
          };

          fission.autostart = true;

          findbar.highlightAll = true;

          geo.provider.network.url = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";

          gfx = {
            canvas.accelerated = {
              cache-items = 4096;
              cache-size = 512;
            };
            content.skia-font-cache-size = 20;
            webrender.all = true;
          };

          image.mem.decode_bytes_at_a_time = 32768;

          layout = {
            css = {
              grid-template-masonry-value.enabled = true;
              has-selector.enabled = true;
            };
            word_select.eat_space_to_next_word = false;
          };

          loop.enabled = false;

          media = {
            memory_cache_max_size = 65536;
            cache_readahead_limit = 7200;
            cache_resume_threshold = 3600;
            navigator.enabled = false;
            peerconnection.ice = {
              proxy_only_if_behind_proxy = true;
              default_address_only = true;
            };
          };

          network = {
            cookie.cookiehardware-video-decoding.enabled = true;
            IDN_show_punycode = true;
            prefetch-next = false;
            predictor.enabled = false;
            cookie.sameSite.noneRequiresSecure = true;
            http = {
              referer.XOriginTrimmingPolicy = 2;
              max-connections = 1800;
              max-persistent-connections-per-server = 10;
              max-urgent-start-excessive-connections-per-host = 5;
              pacing.requests.enabled = false;
            };
            dns = {
              disablePrefetch = true;
              max_high_priority_threads = 8;
            };
            dnsCacheExpiration = 3600;
            ssl_tokens_cache_capacity = 10240;
          };

          permissions = {
            default = {
              desktop-notification = 2;
              geo = 2;
            };
            manager.defaultsUrl = "";
          };

          pdfjs.enableScripting = false;

          privacy = {
            trackingprotection = {
              fingerprinting.enable = true;
              cryptomining.enable = true;
              enable = true;
            };
            history.custom = true;
            userContext.ui.enabled = true;
          };

          reader.parse-on-load = {
            enabled = false;
            force-enabled = false;
          };

          security = {
            dialog_enable_delay = false;
            OCSP.enabled = 0;
            remote_settings.crlite_filters.enabled = true;
            pki.crlite_mode = 2;
            ssl.treat_unsafe_negotiation_as_broken = true;
            tls.enable_0rtt_data = false;
            insecure_connection_text = {
              enabled = true;
              pbmode.enabled = true;
            };
            mixed_content = {
              block_display_content = true;
              # upgrade_display_content = true;
              upgrade_display_content.image = true;
            };
          };

          toolkit = {
            telemetry = {
              enabled = false;
              server = "data:,";
              archive.enabled = false;
              bhrPing.enabled = false;
              coverage.opt-out = true;
              firstShutdownPing.enabled = false;
              hybridContent.enabled = false;
              newProfilePing.enabled = false;
              reportingpolicy.firstRun = false;
              shutdownPingSender.enabled = false;
              unified = false;
              updatePing.enabled = false;
            };
            coverage = {
              opt-out = true;
              endpoint.base = "";
            };
          };

          urlclassifier = {
            trackingSkipURLs = "*.reddit.com, *.twitter.com, *.twimg.com, *.tiktok.com";
            features.socialtracking.skipURLs = "*.instagram.com, *.twitter.com, *.twimg.com";
          };

          webgl.disabled = false;

          webchannel.allowObject.urlWhitelist = "";

          widget.use-xdg-desktop-portal = {
            file-picker = 1;
            mime-handler = 1;
          };
        };
      };
    };
  };
}
