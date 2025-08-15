{
  config,
  pkgs,
  inputs,
  discoveredHomeModules,
  homeSpecificModules,
  ...
} @ moduleArgs: let
  inherit (builtins) attrValues mapAttrs;
  inherit (pkgs) lib;
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
    sharedModules = homeSpecificModules ++ attrValues discoveredHomeModules;
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
