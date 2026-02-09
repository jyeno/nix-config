{
  flake.modules.generic.systemConstants = {
    lib,
    pkgs,
    ...
  }: {
    options.systemConstants = lib.mkOption {
      type = lib.types.attrsOf lib.types.unspecified;
      default = {};
    };

    config.systemConstants = {
      # TODO consider if worth it
      keyboard = {
        binds = let
          # grimblast = lib.getExe pkgs.grimblast;
          steam = "/run/current-system/sw/bin/steam"; # cant call by getExe as steam is configured on the nixos modules
          telegram = lib.getExe pkgs.materialgram;
          firefox = lib.getExe pkgs.firefox;
          light = lib.getExe pkgs.light;
          wpctl = lib.getExe' pkgs.wireplumber "wpctl";
          defaultApp = type: "${pkgs.lib.getExe pkgs.handlr-regex} launch ${type}";
          terminal = lib.getExe pkgs.ghostty;
          menu = lib.getExe pkgs.fuzzel;
          playerctl = lib.getExe pkgs.playerctl; # TODO check if enabled
          mkBindEx = mod: keys: cmd: extras: {inherit mod keys cmd extras;};
          mkBind = mod: keys: cmd: mkBindEx mod keys cmd {};
          modKey = "SUPER";
          useWhenLocked = {locked = true;};
        in [
          # TODO maybe probable actions quit, resize, move, print, screen lock
          # General
          (mkBind modKey ["Return"] "${terminal}")
          (mkBind modKey ["ALT" "Return"] "${defaultApp "x-scheme-handler/terminal"}") # fallback
          (mkBind modKey ["B"] "${firefox}")
          (mkBind modKey ["ALT" "B"] "${defaultApp "x-scheme-handler/https"}") # fallback
          (mkBind modKey ["D"] "${menu}")
          (mkBind modKey ["S"] "${steam}")
          (mkBind modKey ["T"] "${telegram}")
          (mkBind modKey ["E"] "${defaultApp "text/plain"}")
          # Super+Alt+L hotkey-overlay-title="Lock the Screen: swaylock" { spawn "swaylock"; }
          # Brightness control (only works if the system has lightd)
          (mkBindEx "" ["XF86MonBrightnessUp"] "${light} -A 10" useWhenLocked)
          (mkBindEx "" ["XF86MonBrightnessDown"] "${light} -U 10" useWhenLocked)
          # Volume
          (mkBindEx "" ["XF86AudioRaiseVolume"] "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0" useWhenLocked)
          (mkBindEx "" ["XF86AudioLowerVolume"] "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.1-" useWhenLocked)
          (mkBindEx "" ["XF86AudioMute"] "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle" useWhenLocked)
          (mkBindEx "SHIFT" ["XF86AudioMute"] "${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle" useWhenLocked)
          (mkBindEx "" ["XF86AudioMicMute"] "${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle" useWhenLocked)
          # Player
          (mkBindEx "" ["XF86AudioPlay"] "${playerctl} play-pause" useWhenLocked)
          (mkBindEx "" ["XF86AudioStop"] "${playerctl} stop" useWhenLocked)
          (mkBindEx "" ["XF86AudioPrev"] "${playerctl} previous" useWhenLocked)
          (mkBindEx "" ["XF86AudioNext"] "${playerctl} next" useWhenLocked)
          (mkBindEx "ALT" ["XF86AudioNext"] "${playerctl}d shift" useWhenLocked)
          (mkBindEx "ALT" ["XF86AudioPrev"] "${playerctl}d unshift" useWhenLocked)
          # Screenshotting
          # (mkBind "" ["Print"] "${grimblast} --notify copy output") #TODO decide which tool to use
          # (mkBind modKey ["Print"] "${grimblast} --notify copy area")
        ];
        xkb = {
          layout = "us,us,us";
          variant = "intl,workman-intl,colemak_dh";
          options = "ctrl:nocaps,caps:ctrl_shifted_capslock,grp:win_space_toggle";
        };
        repeatDelay = 250;
        repeatRate = 25;
      };
    };
  };
}
