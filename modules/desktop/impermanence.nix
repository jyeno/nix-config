{inputs, ...}: {
  flake.modules.homeManager.desktop-general = {
    config,
    lib,
    pkgs,
    ...
  }: {
    home = inputs.self.lib.mkIfPersistence config {
      # home = {
      persistence."${config.systemConstants.persistDir}" = {
        directories =
          [
            # TODO check if a program like steam (from system, not hm)
            ".local/share/Steam"
            ".config/wivrn"
            ".config/vesktop"
            ".config/r2modman"
            ".config/r2modmanPlus-local"
            ".config/chromium"
            ".config/qutebrowser/greasemonkey"
            ".local/share/qutebrowser"
            ".mozilla/firefox" # /${username}
            ".cache/lm-studio"
            ".local/share/materialgram"
          ]
          ++ lib.optionals (lib.elem pkgs.ryubing config.home.packages) [
            ".config/Ryujinx"
            # ]
            # ++ lib.optionals (lib.elem pkgs.wivrn config.home.packages) [
            #   ".config/wivrn"
            # ]
            # ++ lib.optionals (lib.elem pkgs.vesktop config.home.packages) [
            #   ".config/vesktop"
            # ]
            # ++ lib.optionals (lib.elem pkgs.r2modman config.home.packages) [
            #   ".config/r2modman"
            #   ".config/r2modmanPlus-local"
            # ]
            # ++ lib.optionals (lib.elem pkgs.chromium config.home.packages) [
            #   ".config/chromium"
            # ]
            # ++ lib.optionals (lib.elem pkgs.qutebrowser config.home.packages) [
            #   ".config/qutebrowser/greasemonkey"
            #   ".local/share/qutebrowser"
            # ]
            # ++ lib.optionals (lib.elem pkgs.firefox config.home.packages) [
            #   ".mozilla/firefox"
            # ]
            # ++ lib.optionals (lib.elem pkgs.lmstudio config.home.packages) [
            #   ".cache/lm-studio"
            # ]
            # ++ lib.optionals (lib.elem pkgs.materialgram config.home.packages) [
            #   ".local/share/materialgram"
          ];
      };
    };
  };
}
