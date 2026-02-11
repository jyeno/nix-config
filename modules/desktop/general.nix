{
  flake.modules.nixos.desktop-general = {
    config,
    pkgs,
    lib,
    ...
  }: {
    services.xserver = {
      enable = true; # maybe use constants for the layout, variant options
      xkb = {
        layout = "us";
        variant = "workman-intl";
      };
    };
    services.greetd.enable = lib.mkDefault true;
    programs.regreet.enable = lib.mkDefault true;
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
      pkgs.lsfg-vk
      pkgs.lsfg-vk-ui
    ];
  };

  flake.modules.homeManager.desktop-general = {pkgs, ...}: {
    programs.zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
        recolor = true;
      };
    };
  };
}
