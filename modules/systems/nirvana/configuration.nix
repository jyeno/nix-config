{inputs, ...}: {
  flake.modules.nixos.nirvana = {
    lib,
    pkgs,
    ...
  }: {
    imports = with inputs.self.modules.nixos; [
      system-cli
      systemd-boot

      services-podman

      gaming-xonotic-server
    ];
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
    # locale.timezone = "America/Sao_Paulo";
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
    nixpkgs.hostPlatform = "aarch64-linux";
  };
}
