{
  lib,
  localLib,
  ...
}: {
  # imports = lib.attrsets.attrValues (localLib.discoverModules ./.);
  imports = [
    ./bluetooth.nix
    ./docker.nix
    ./home-dns.nix
    ./iwd.nix
    ./jenkins.nix
    ./mysql.nix
    ./openssh.nix
    ./pipewire.nix
    ./podman.nix
    ./postgres.nix
    ./tlp.nix
  ];
}
