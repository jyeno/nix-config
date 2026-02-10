{inputs, ...}: {
  # import all essential nix-tools which are used in all modules of a specific class

  flake.modules.nixos.system-cli = {
    imports = with inputs.self.modules.nixos;
      [
        system-minimal
        home-manager

        systemd-boot
        locale
        networking

        cli-tools
        cli-fish

        services-openssh
      ]
      ++ [
        inputs.self.modules.generic.systemConstants
      ];
  };

  flake.modules.homeManager.system-cli = {
    imports = with inputs.self.modules.homeManager;
      [
        system-minimal
        cli-tools
      ]
      ++ [
        inputs.self.modules.generic.systemConstants
      ];
  };
}
