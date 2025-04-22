{
  pkgs,
  config,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
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
    (builtins.readFile ../../extras/pubkeys/id_jyeno.pub)
  ];
}
