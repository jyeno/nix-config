{
  config,
  lib,
  ...
}: let
  cfg = config.local.home.cli.git;
in {
  options.local.home.cli.git = {
    enable = lib.mkEnableOption "Enable git configuration";
    delta = {
      enable = lib.mkEnableOption "Enable delta-git";
      settings = lib.mkOption {
        type = lib.types.attrs;
        default = {
          decorations = {
            commit-decoration-style = "bold yellow box ul";
            file-decoration-style = "none";
            file-style = "bold yellow ul";
          };
          features = "decorations";
          whitespace-error-style = "22 reverse";
        };
        description = "delta options";
      };
    };
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {
        alias = {
          co = "checkout";
          unstage = "reset HEAD --";
          cm = "commit";
          cmm = "commit -p -m";
          st = "status -s";
          br = "branch";
          fp = "fetch -p";
          lfive = "log -5 HEAD --decorate  --oneline --graph";
          l = "log --pretty=format:\"%C(yellow)%h %ad%Cred%d %Creset%s%Cblue [%cn]\" --decorate --date=relative --graph";
          ds = "diff --staged";
          d = "diff --word-diff";
          cl = "clone";
          rb = "rebase";
          pll = "pull origin";
          psh = "push origin";
        };
        core.whitespace = "trailing-space,space-before-tab";
        url = {
          "https://gitlab.com/" = {
            insteadOf = "gl:";
          };
          "https://github.com/" = {
            insteadOf = "gh:";
          };
        };
        pull.rebase = true;
        init.defaultBranch = "master";
      };
      description = "git extraConfig setting";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.delta = {
      enable = cfg.delta.enable;
      options = cfg.delta.settings;
    };
    programs.git = {
      enable = lib.mkDefault true;
      inherit (cfg) settings;
      #hooks = {
      #  pre-commit = ./pre-commit-script;
      #};
    };
  };
}
