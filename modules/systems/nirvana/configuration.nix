{inputs, ...}: {
  flake.modules.nixos.nirvana = {
    lib,
    pkgs,
    modulesPath,
    ...
  }: {
    imports = with inputs.self.modules.nixos;
      [
        system-cli

        services-podman

        gaming-xonotic-server
      ]
      ++ [
        (modulesPath + "/profiles/qemu-guest.nix")
      ];
    flake.modules = let
      mkUser = name: deps: packages: {inherit name deps packages;};
      mkUserName = name: mkUser name [] [];
      users = [(mkUserName "cassio") (mkUserName "igorcafe") (mkUserName "oliver") (mkUserName "leonardohn") (mkUser "jyeno" (with inputs.self.moudles.homeManager; [tmux git fish nvf]) (with pkgs; [ripgrep fq eza nix-output-monitor]))];
    in
      lib.mkMerge [
        (builtins.map (user:
          lib.mkMerge [
            (inputs.self.factory.user "${user.name}" true)
            {
              flake.homeConfigurations = inputs.self.lib.mkHomeManager "aarch64-linux" "${user.name}";

              nixos."${user.name}" = {
                users.users."${user.name}" = {
                  openssh.authorizedKeys.keys = [
                    (builtins.readFile "../../extras/pubkeys/id_${user.name}.pub")
                  ];
                };
              };

              homeManager."${user.name}" = {
                imports = with inputs.self.modules.homeManager;
                  [
                    system-cli
                  ]
                  ++ user.deps;
                home.packages = user.packages;
              };
            }
          ])
        users)
      ];
    time.timezone = "America/Sao_Paulo";
    networking = {
      hostName = "nirvana";
      domain = "privatedns.org";
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
    boot = {
      initrd = {
        availableKernelModules = ["xhci_pci" "usbhid" "virtio_pci" "virtio_scsi"];
        kernelModules = [];
      };
      kernelPackages = pkgs.linuxPackages_latest;
      kernelParams = ["net.ifnames=0"];
      extraModulePackages = [];
      tmp = {
        useTmpfs = true;
        tmpfsSize = "8G";
      };
    };

    # fileSystems."/".neededForBoot = true;

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/2ba400bb-3ec6-43a3-9661-0f2e5d109368";
        fsType = "xfs";
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/A77B-82BC";
        fsType = "vfat";
        options = [
          "defaults"
          "nodev"
          "noexec"
          "nosuid"
          "dmask=0077"
          "fmask=0077"
        ];
      };
    };

    nixpkgs.hostPlatform = "aarch64-linux";
    # TODO add x86 overlay
    #pkgs = import inputs.nixpkgs {
    #  inherit system;
    #  config.allowUnfree = true;
    #  overlays = [
    #    (final: prev: {
    #      x86 = import inputs.nixpkgs {
    #        system = "x86_64-linux";
    #        #modules = [inputs.chaotic.nixosModules.default];
    #        config.allowUnfree = true;
    #      };
    #    })
    #  ];
    #};
  };
}
