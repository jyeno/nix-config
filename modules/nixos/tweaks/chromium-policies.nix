{
  config,
  lib,
  ...
}: let
  cfg = config.local.tweaks.chromium-policies;
in {
  #TODO add more options for all of those settings
  options.local.tweaks.chromium-policies.enable = lib.mkEnableOption "Enable custom Chromium policies";
  config = lib.mkIf cfg.enable {
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
      WebRtcLocalIpsAllowedUrls = [];

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
}
