{
  inputs,
  hostname,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    # ./disko.nix TODO fix not working
  ];

  documentation.man.enable = false;
  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "25.05";

  local = {
    users = {
      cassio = {
        enable = true;
        keys = [
          (builtins.readFile ../../extras/pubkeys/id_cassio.pub)
        ];
      };
      igorcafe = {
        enable = true;
        keys = [
          (builtins.readFile ../../extras/pubkeys/id_igorcafe.pub)
        ];
      };
      jyeno = {
        enable = true;
        home.config = {
          home.packages = with pkgs; [
            zip
            xz
            unzip
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
            pciutils
            nix-output-monitor
          ];

          local.home.cli = {
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
          };
        };
        keys = [
          (builtins.readFile ../../extras/pubkeys/id_jyeno.pub)
        ];
      };
      oliver = {
        enable = true;
        keys = [
          (builtins.readFile ../../extras/pubkeys/id_oliver.pub)
        ];
      };
      leonardohn = {
        enable = true;
        keys = [
          (builtins.readFile ../../extras/pubkeys/id_leonardohn.pub)
        ];
      };
    };
    cli = {
      enable = true;
      mtr = true;
      # gnuAgent = true;
    };
    misc = {
      networking = {
        hostName = hostname;
        nameservers = ["8.8.8.8" "1.1.1.1"];
        interfaces.eth0 = {
          ipv4.addresses = [
            {
              address = "10.0.0.90";
              prefixLength = 24;
            }
          ];
          useDHCP = true;
        };
        firewall = {
          enable = true;
          allowedTCPPorts = [22];
          allowedTCPPortRanges = [
            {
              from = 25500;
              to = 25599;
            }
          ];
          allowedUDPPortRanges = [
            {
              from = 25500;
              to = 25599;
            }
          ];
          logRefusedConnections = false;
          rejectPackets = true;
        };
      };
      boot.enable = true;
      locale = {
        enable = true;
        timezone = "America/Sao_Paulo";
      };
      persistent.enable = false;
      sops.enable = false;
    };
    service = {
      home-dns.enable = false;
      openssh = {
        enable = true;
        hostKeys = [];
      };
      podman.enable = true;
      docker.enable = false;
    };
    tweaks = {
      # io-schedulers.enable = true;
      nix.enable = true; # TODO change name
    };
  };
}
