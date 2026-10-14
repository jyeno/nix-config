{
  flake.modules.nixos.desktop-chromium =
    { pkgs, ... }:
    {
      environment.etc."/chromium/policies/managed/default.json".text = builtins.toJSON {
        RestoreOnStartup = 1;
        HomepageLocation = "https://chat.qwenlm.ai";
        ShowHomeButton = true;
        BookmarkBarEnabled = false;

        PasswordManagerEnabled = false;
        SafeBrowsingProtectionLevel = 2;
        BlockThirdPartyCookies = true;
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        SyncDisabled = true;
        MetricsReportingEnabled = false;
        SearchSuggestEnabled = false;
        SpellCheckServiceEnabled = false;
        TranslateEnabled = false;
        NetworkPredictionOptions = 2;
        WebRtcLocalIpsAllowedUrls = [ ];

        ClearBrowsingDataOnExitList = [
          # "browsing_history"
          "download_history"
          # "cookies_and_other_site_data"
          "cached_images_and_files"
          "password_signin"
          "autofill"
        ];

        DefaultSearchProviderEnabled = true;
        DefaultSearchProviderName = "DuckDuckGo";
        DefaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";

        SiteSearchSettings = [
          {
            name = "Nix Packages";
            shortcut = "np";
            url = "https://search.nixos.org/packages?query={searchTerms}";
          }
          {
            name = "Nixos Wiki";
            shortcut = "nw";
            url = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
          }
          {
            name = "Nix Options";
            shortcut = "no";
            url = "https://search.nixos.org/options?query={searchTerms}";
          }
        ];
      };
    };

  flake.modules.homeManager.desktop-chromium =
    { pkgs, ... }:
    {
      programs.chromium = {
        enable = true;
        package = pkgs.ungoogled-chromium;
        commandLineArgs = [
          "--enable-features=AcceleratedVideoEncoder,WebUIDarkMode,AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoDecodeLinuxGL,VaapiIgnoreDriverChecks,webgpu,webgl2,rasterization,video_encode,video_decode,webgl,gpu_compositing,2d_canvas"
          "--ignore-gpu-blocklist"
          "--enable-zero-copy"
          "--force-dark-mode"
        ];
        #TODO add script to download and update any plugin listed here
        extensions = [
          {
            # ublock origin
            id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
            crxPath = ../../../extras/desktop/chromium_extensions/ublock_origin.crx;
            version = "1.62.0";
          }
          {
            # browser pass
            id = "naepdomgkenhinolocfifgehidddafch";
            crxPath = ../../../extras/desktop/chromium_extensions/browser_pass.crx;
            version = "3.9.0";
          }
          {
            # automa
            id = "infppggnoaenmfagbfknfkancpbljcca";
            crxPath = ../../../extras/desktop/chromium_extensions/automa.crx;
            version = "1.29.8";
          }
          {
            # augmented steam
            id = "dnhpnfgdlenaccegplpojghhmaamnnfp";
            crxPath = ../../../extras/desktop/chromium_extensions/augmented_steam.crx;
            version = "4.2.1";
          }
          {
            # tamper monkey
            id = "dhdgffkkebhmkfjojejmpbldmpobfkfo";
            crxPath = ../../../extras/desktop/chromium_extensions/tamper_monkey.crx;
            version = "5.3.3";
          }
          {
            # ttv lol pro
            id = "bpaoeijjlplfjbagceilcgbkcdjbomjd";
            crxPath = ../../../extras/desktop/chromium_extensions/ttv_lol_pro.crx;
            version = "2.4.0";
          }
          {
            # link map
            id = "jappgmhllahigjolfpgbjdfhciabdnde";
            crxPath = ../../../extras/desktop/chromium_extensions/link_map.crx;
            version = "1.1.7";
          }
          {
            # vimium
            id = "dbepggeogbaibhgnhhndojpepiihcmeb";
            crxPath = ../../../extras/desktop/chromium_extensions/vimium.crx;
            version = "2.2.0";
          }
          {
            # noscript
            id = "doojmbjmlfjjnbmnoijecmcbfeoakpjm";
            crxPath = ../../../extras/desktop/chromium_extensions/noscript.crx;
            version = "12.1.1";
          }
        ];
      };
    };
}
