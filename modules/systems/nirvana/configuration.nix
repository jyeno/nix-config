{
  inputs,
  lib,
  ...
}: {
  flake.modules.nixos.nirvana = {
    imports = with inputs.self.modules.nixos; [
      desktop
      systemd-boot
      services
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
    # TODO add jyeno-cli
    flake.modules = let
      users = ["cassio" "igorcafe" "oliver" "leonardohn"];
    in
      lib.mkMerge [
        (builtins.map (username:
          lib.mkMerge [
            (inputs.self.factory.user "${username}" true)
            {
              nixos."${username}" = {
                users.users."${username}" = {
                  openssh.authorizedKeys.keys = [
                    (builtins.readFile "../../extras/pubkeys/id_${username}.pub")
                  ];
                };
              };

              # TODO personalize some modules like the ssh one
              homeManager."${username}" = {
                imports = with inputs.self.modules.homeManager; [
                  system-cli
                ];
              };
            }
          ])
        users)
      ];
    networking.useDHCP = true;
    nixpkgs.hostPlatform = "aarch64-linux";
  };
}
