{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.users.user;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  options.local.users.user = {
    enable = lib.mkEnableOption "Enable user user";
    homeConfig = lib.mkOption {
      type = lib.types.attrs;
      default = import ./home.nix {inherit pkgs config;};
      description = "Home manager configuration";
    };
  };
  config.users.users = lib.mkIf cfg.enable {
    user = {
      isNormalUser = true;
      description = "monke";
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
        (builtins.readFile ../../../extras/pubkeys/id_jyeno.pub)
        (builtins.readFile ../../../extras/pubkeys/id_leonardohn.pub)
      ];
    };
  };
  config.home-manager.users = lib.mkIf cfg.enable {
    user = cfg.homeConfig;
  };
}
