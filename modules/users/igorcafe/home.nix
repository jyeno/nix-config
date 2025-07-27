{pkgs, ...}: {
  home.username = "igorcafe";
  home.homeDirectory = "/home/igorcafe";

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "25.05";
}
