{
  flake.modules.homeManager.desktop-qutebrowser = {
    pkgs,
    lib,
    ...
  }: {
    programs.qutebrowser = {
      enable = true;
      loadAutoconfig = true;
      searchEngines = rec {
        duckduckgo = "https://duckduckgo.com/?q={}";
        google = "https://google.com/search?hl=en&q={}";
        np = "https://search.nixos.org/packages?query={}";
        nw = "https://wiki.nixos.org/w/index.php?search={}";
        sx = "https://find.xenorio.xyz/search?q={}";
        ddg = duckduckgo;
        g = google;
        DEFAULT = google;
      };
      keyBindings = {
        normal = {
          "<Ctrl-v>" = "spawn mpv {url}";
          ",p" = "spawn --userscript qute-pass";
          ",l" = ''config-cycle spellcheck.languages ["en-GB"] ["en-US"]'';
          "<F1>" = lib.mkMerge [
            "config-cycle tabs.show never always"
            "config-cycle statusbar.show in-mode always"
            "config-cycle scrolling.bar never always"
          ];
        };
        prompt = {
          "<Ctrl-y>" = "prompt-yes";
        };
      };
      perDomainSettings = {
        "zoom.us" = {
          content = {
            autoplay = true;
            media.audio_capture = true;
            media.video_capture = true;
          };
        };
        "github.com".colors.webpage.darkmode.enabled = false;
      };
      settings = {
        url = rec {
          default_page =
            if true # glanceEnabled
            then "0.0.0.0:8080"
            else "https://online.bonjourr.fr";
          start_pages = [default_page];
        };
        downloads.open_dispatcher = "${lib.getExe pkgs.handlr-regex} open {}";
        editor.command = ["${lib.getExe pkgs.handlr-regex}" "open" "{file}"];
        colors.webpage.darkmode.enabled = true;
        auto_save.session = true;
        content = {
          autoplay = true;
          blocking = {
            enabled = true;
            adblock.lists = [
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-general.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2022.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2023.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2024.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2025.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-cookies.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-others.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/quick-fixes.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt"
            ];
          };
        };
        tabs = {
          show = "multiple";
          position = "left";
          indicator.width = 0;
        };
        # Also avoids qutebrowser stealing focus when reloading
        new_instance_open_target = "window";
      };
      extraConfig = ''
        c.tabs.padding = {"bottom": 10, "left": 10, "right": 10, "top": 10}
      '';
    };
  };
}
