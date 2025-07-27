{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking = {
    # TODO put it on flake.nix
    hostName = "nirvana";
  };

  time.timeZone = "America/Sao_Paulo";

  system.stateVersion = "25.05";

  local = {
    users.cassio.enable = true;
    users.igorcafe.enable = true;
    users.jyeno.enable = true;
    users.oliver.enable = true;
    cli = {
      enable = true;
      mtr = true;
      gnuAgent = true;
    };
    misc = {
      firewall = {
        enable = true;
        # nameservers = [];
      };
      boot.enable = true;
      locale.enable = true;
      persistent.enable = false;
    };
    service = {
      home-dns.enable = false;
      openssh = {
        enable = true;
        hostKeys = [];
      };
      podman.enable = false;
      docker.enable = true;
    };
    tweaks = {
      # io-schedulers.enable = true;
      nix = {
        enable = true; # TODO change name
        allowUnfree = true;
      };
    };
  };
}
