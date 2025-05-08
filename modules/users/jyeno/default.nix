{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.users.jyeno;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  options.local.users.jyeno = {
    enable = lib.mkEnableOption "Enable jyeno user";
    homeConfig = lib.mkOption {
      type = lib.types.nullOr lib.types.attrs;
      default = import ./home.nix {inherit pkgs config;};
      description = "Home manager configuration";
    };
  };
  config.users.users = lib.mkIf cfg.enable {
    jyeno = {
      isNormalUser = true;
      description = "me";
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
      ];
    };
  };
  config.home-manager.users = lib.mkIf (cfg.homeConfig != null) {
    jyeno = cfg.homeConfig;
  };
}
