{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs) lib;
in {
  options.local.users = lib.mkOption {
    default = {};
    description = "user settings";
    type = with lib.types;
      attrsOf (submodule {
        options = {
          enable = lib.mkEnableOption "Enable user configuration";
          home = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Enable home manager for user";
            };
            config = lib.mkOption {
              type = lib.types.attrs;
              default = {};
              description = "User home configuration";
            };
            sessionVariables = lib.mkOption {
              type = lib.types.attrs;
              default = {
                # Avoid unfree errors
                NIXPKGS_ALLOW_UNFREE = 1;
                # True color support
                TERM = "xterm-256color";
                COLORTERM = "truecolor";
              };
              description = "home env vars settings";
            };
          };
          keys = lib.mkOption {
            type = with lib.types; listOf str;
            default = [];
            description = "ssh public keys";
          };
          shell = lib.mkOption {
            type = lib.types.package;
            default = pkgs.fish;
            description = "user shell";
          };
          extraGroups = lib.mkOption {
            type = with lib.types; listOf str;
            default = let
              #TODO maybe wrong to let it here
              ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
            in
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
            description = "List of user groups";
          };
        };
      });
  };
}
