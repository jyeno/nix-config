{
  lib,
  pkgs,
  ...
}: {
  environment.packages = with pkgs; [
    neovim
    git
    curl
  ];
  environment.etcBackupExtension = ".bak";

  nix.extraOptions = ''
    experimental-features = nix-command flakes pipe-operators
  '';
  time.timeZone = "America/Bahia";

  system.stateVersion = "24.05";
}
