{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.users.oliver;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  options.local.users.oliver = {
    enable = lib.mkEnableOption "Enable oliver user";
    homeConfig = lib.mkOption {
      type = lib.types.attrs;
      default = import ./home.nix {inherit pkgs config;};
      description = "Home manager configuration";
    };
  };
  config.users.users = lib.mkIf cfg.enable {
    oliver = {
      isNormalUser = true;
      description = "Nordeste do Sul - oliver";
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
        # (builtins.readFile ../../../extras/pubkeys/id_cassio.pub)
        (builtins.readFile ../../../extras/pubkeys/id_oliver.pub)
        # (builtins.readFile ../../../extras/pubkeys/id_igorcafe.pub)
      ];
    };
  };
  config.home-manager.users = lib.mkIf cfg.enable {
    oliver = cfg.homeConfig;
  };
}
