{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.local.home.desktop.chromium;
  glanceEnabled = true; #TODO fix
in {
  options.local.home.desktop.qutebrowser = {
    enable = lib.mkEnableOption "Enable qutebrowser configuration";
  };
  config = lib.mkIf cfg.enable {
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
      settings = {
        url = rec {
          default_page =
            if glanceEnabled
            then "0.0.0.0:8080"
            else "https://online.bonjourr.fr";
          start_pages = [default_page];
        };
        downloads.open_dispatcher = "${lib.getExe pkgs.handlr-regex} open {}";
        editor.command = ["${lib.getExe pkgs.handlr-regex}" "open" "{file}"];
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
