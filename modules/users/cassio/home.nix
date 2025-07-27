{pkgs, ...}: {
  home.username = "cassio";
  home.homeDirectory = "/home/cassio";

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "25.05";
}
