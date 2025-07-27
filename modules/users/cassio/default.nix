{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.users.cassio;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  options.local.users.cassio = {
    enable = lib.mkEnableOption "Enable cassio user";
    homeConfig = lib.mkOption {
      type = lib.types.attrs;
      default = import ./home.nix {inherit pkgs config;};
      description = "Home manager configuration";
    };
  };
  config.users.users = lib.mkIf cfg.enable {
    cassio = {
      isNormalUser = true;
      description = "Nordeste do Sul - cassio";
      shell = pkgs.fish;
      ignoreShellProgramCheck = true;
      extraGroups =
        [
          "wheel"
          "video"
          "audio"
          "input"
        ]
        ++ ifTheyExist [
          "network"
          "seat"
          "wireshark"
          "i2c"
          "mysql"
          "docker"
          "podman"
          "git"
          "libvirtd"
          "deluge"
          "gamemode"
        ];
      openssh.authorizedKeys.keys = [
        (builtins.readFile ../../../extras/pubkeys/id_cassio.pub)
      ];
    };
  };
  config.home-manager.users = lib.mkIf cfg.enable {
    cassio = cfg.homeConfig;
  };
}
