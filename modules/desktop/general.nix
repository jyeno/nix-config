{
  flake.modules.nixos.desktop-general =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      services.xserver = lib.mkDefault {
        enable = true;
        xkb = {
          layout = "us";
          variant = "workman-intl";
        };
      };
      services.displayManager =
        lib.mkIf
          (
            config.services.displayManager.sddm.enable == false
            && config.services.displayManager.gdm.enable == false
          )
          {
            lemurs.enable = true;
          };
      # TODO move
      services.fstrim.enable = true;
      services.bpftune.enable = true;

      environment.systemPackages = [
        (pkgs.wrapOBS {
          plugins = with pkgs.obs-studio-plugins; [
            obs-backgroundremoval
            obs-pipewire-audio-capture
            obs-source-clone
            obs-vkcapture
          ];
        })
        # pkgs.lsfg-vk
        # pkgs.lsfg-vk-ui
      ];
      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (subject.isInGroup("wheel"))
            return polkit.Result.YES;
        });
      '';
    };

  flake.modules.homeManager.desktop-general =
    {
      pkgs,
      lib,
      ...
    }:
    {
      programs.zathura = lib.mkDefault {
        enable = true;
        options = {
          selection-clipboard = "clipboard";
          recolor = true;
        };
      };
    };
}
