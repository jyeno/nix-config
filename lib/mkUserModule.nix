{
config,
pkgs,
inputs,
localLib,
...
} @ moduleArgs: let
  inherit (builtins) attrValues mapAttrs;
  inherit (pkgs) lib;
  discoveredHomeModules = localLib.discoverModules ../modules/hm;
in {
  users.users =
    mapAttrs
    (
      username: userConfig:
      lib.optionals userConfig.enable
      {
        isNormalUser = true;
        description = "user ${username}";
        shell = userConfig.shell;
        ignoreShellProgramCheck = lib.mkDefault true;
        extraGroups = userConfig.extraGroups;
        openssh.authorizedKeys.keys = userConfig.keys;
      }
    )
    config.local.users;
  home-manager = {
    extraSpecialArgs = {inherit inputs moduleArgs;};
    sharedModules =
      lib.traceVal (attrValues discoveredHomeModules)
      ++ [ #TODO consider if it should be here, and where to put instead
        inputs.sops-nix.homeManagerModules.sops
        inputs.nvf.homeManagerModules.default
        inputs.impermanence.nixosModules.home-manager.impermanence
        # inputs.gBar.homeManagerModules.x86_64-linux.default
        inputs.plasma-manager.homeManagerModules.plasma-manager
      ];
    useGlobalPkgs = true;
    users =
      mapAttrs (
        username: userConfig:
        lib.optionals (userConfig.enable && userConfig.home.enable)
        (let
          baseHomeConfig = {
            home = {
              inherit username;
              homeDirectory = "/home/${username}";
              stateVersion = "25.05";

              packages = with pkgs; [
                git
                home-manager
                neovim
                tmux
              ];
              sessionVariables = userConfig.home.sessionVariables;
            };

            programs.home-manager.enable = true;
            systemd.user.startServices = "sd-switch";
          };
        in
          lib.recursiveUpdate baseHomeConfig userConfig.home.config)
      )
      config.local.users;
  };
}
