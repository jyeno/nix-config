{ self, ... }:
{
  flake.factory.user = username: isAdmin: {
    nixos."${username}" =
      {
        lib,
        pkgs,
        config,
        ...
      }:
      let
        ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
      in
      {
        users.users."${username}" = {
          isNormalUser = true;
          home = "/home/${username}";
          shell = pkgs.fish;
          extraGroups =
            lib.optionals isAdmin [
              "wheel"
            ]
            ++ [
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
        };

        home-manager.users."${username}".imports = [
          self.modules.homeManager."${username}"
        ];
      };

    homeManager."${username}" =
      { pkgs, ... }:
      {
        home = {
          username = "${username}";
          packages = with pkgs; [
            unzip
            ripgrep
            jq
            eza
            dnsutils
            socat
            nmap
            file
            which
            gnutar
          ];
        };
        programs.home-manager.enable = true;
        systemd.user.startServices = "sd-switch";
      };
  };
}
