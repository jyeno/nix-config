{pkgs, ...}: {
  home.username = "oliver";
  home.homeDirectory = "/home/oliver";

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "25.05";
}
