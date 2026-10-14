{
  flake.modules.homeManager.desktop-foot = {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        mouse.hide-when-typing = "yes";
        main = {
          term = "xterm-256color";
          selection-target = "clipboard";
        };
        scrollback = {
          lines = 100000;
          multiplier = 3;
        };
        cursor = {
          style = "underline";
          blink = "yes";
        };
      };
    };
  };
}
