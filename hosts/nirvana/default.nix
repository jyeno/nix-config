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
    interfaces.eth0 = {
      ipv4.addresses = [
        {
          # Use IP address configured in the Oracle Cloud web interface
          address = "10.0.0.90";
          prefixLength = 24;
        }
      ];
      # Only "required" for IPv6, can be false if only IPv4 is needed
      useDHCP = true;
    };
    # Note: you also need to configure open ports in the Oracle Cloud web interface
    # (Virtual Cloud Network -> Security Lists -> Ingress Rules)
    firewall = {
      # (both optional)
      logRefusedConnections = false;
      rejectPackets = true;
    };
  };

  system.stateVersion = "25.05";
  networking.firewall.allowedTCPPorts = [22];

  local = {
    users.cassio.enable = true;
    users.igorcafe.enable = true;
    users.jyeno = {
      enable = true;
      homeConfig = {
        home.username = "jyeno";
        home.homeDirectory = "/home/jyeno";

        home.packages = with pkgs; [
          #cli
          zip
          xz
          unzip
          p7zip
          ripgrep
          jq
          eza
          dnsutils
          socat
          nmap
          file
          which
          gnused
          gnutar
          gawk
          strace
          lsof
          lm_sensors
          usbutils
          pciutils
          age
          spotdl
          nix-output-monitor
        ];

        programs.home-manager.enable = true;

        systemd.user.startServices = "sd-switch";
        home.stateVersion = "25.05";

        local.home = {
          cli = {
            fish = {
              enable = true;
              starship.enable = true;
            };
            git.enable = true;
            gpg.enable = true;
            nvf.enable = true;
            fd.enable = true;
            fzf.enable = true;
            aria2.enable = true;
            bat.enable = true;
            ssh.enable = true;
            tmux.enable = true;
            direnv.enable = true;
            yt-dlp.enable = true;
          };
        };
      };
    };
    users.oliver.enable = true;
    cli = {
      enable = true;
      mtr = true;
      gnuAgent = true;
    };
    misc = {
      firewall = {
        enable = true;
        nameservers = ["8.8.8.8" "1.1.1.1"];
      };
      boot.enable = true;
      locale = {
        enable = true;
        timezone = "America/Sao_Paulo";
      };
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
