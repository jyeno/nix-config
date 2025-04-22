{...}: {
  local = {
    cli = {
      enable = true;
      mtr = true;
      gnuAgent = true;
    };
    desktop = {
      enable = true;
      graphics = {
        enable = true;
        # xkb = {};
      };
      hyprland.enable = true;
      riverwm.enable = false;
      nvidia.enable = true;
      plasma.enable = false;
      wireshark.enable = false;
    };
    gaming = {
      enable = true;
      #gamescope = {};
      lact.enable = true;
    };
    misc = {
      enable = true;
      firewall.enable = true;
      boot.enable = true;
      locale.enable = true;
      persistent.enable = true;
      sops.enable = true;
      virtualisation.enable = true;
      zram.enable = true;
    };
    service = {
      enable = true;
      bluetooth.enable = true;
      docker.enable = true;
      home-dns.enable = true;
      iwd.enable = true;
      jenkins.enable = false;
      mysql.enable = false;
      openssh.enable = true;
      pipewire.enable = true;
      podman.enable = false;
      postgres.enable = false;
      tlp.enable = true;
    };
    tweaks = {
      enable = true;
      chromium-policies.enable = true;
      fonts.enable = true;
      io-schedulers.enable = true;
      nix.enable = true;
    };
    home = {
      cli = {
        enable = true;
        fish.enable = true;
        git.enable = true;
        gpg.enable = true;
        mpd.enable = true;
        neomutt.enable = true;
        neovim.enable = false;
        newsboat.enable = true;
        nvf.enable = true;
        ssh.enable = true;
        tmux.enable = true;
      };
      desktop = {
        enable = true;
        chromium.enable = true;
        firefox.enable = true;
        ghostty.enable = true;
        zathura.enable = true;
      };
      misc = {
        enable = true;
        persistent.enable = true;
        sops.enable = true;
        sound.enable = true;
      };
      wayland = {
        enable = true;
        cliphist.enable = true;
        fnott.enable = true;
        foot.enable = true;
        hypridle.enable = true;
        hyprland.enable = true;
        hyprlock.enable = true;
        riverwm.enable = false;
        ashell.enable = true;
        gbar.enable = false;
        waybar.enable = false;
        wofi.enable = true;
        yambar.enable = false;
      };
    };
  };
}
