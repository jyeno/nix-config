{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.home.cli.git;
in {
  options.local.home.cli.git = {
    enable = lib.mkEnableOption "Enable git configuration";
    aliases = lib.mkOption {
      type = lib.types.attrs;
      default = {
        co = "checkout";
        cip = "commit -p -m";
        unstage = "reset HEAD --";
        ci = "commit";
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
      description = "git aliases";
    };
    delta.enable = lib.mkEnableOption "Enable delta-git";
    userName = lib.mkOption {
      type = lib.types.str;
      default = "Jean Lima Andrade";
      description = "git user's name setting";
    };
    userEmail = lib.mkOption {
      type = lib.types.str;
      default = "jeno.andrade@gmail.com";
      description = "git user's name setting";
    };
    extraConfig = lib.mkOption {
      type = lib.types.attrs;
      default = {
        core = {
          whitespace = "trailing-space,space-before-tab";
          editor = "nvim";
        };
        url = {
          "ssh://git@gitlab.com:" = {
            insteadOf = "gitlab";
          };
          "ssh://git@github.com:" = {
            insteadOf = "github";
          };
        };
        pull.rebase = lib.mkDefault false;
        init.defaultBranch = lib.mkDefault "master";
      };
      description = "git extraConfig setting";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = lib.mkDefault true;
      delta = {
        enable = cfg.delta.enable; # TODO add more options
        options = {
          decorations = {
            commit-decoration-style = "bold yellow box ul";
            file-decoration-style = "none";
            file-style = "bold yellow ul";
          };
          features = "decorations";
          whitespace-error-style = "22 reverse";
        };
      };
      userName = cfg.userName;
      userEmail = cfg.userEmail;
      #hooks = {
      #  pre-commit = ./pre-commit-script;
      #};
      extraConfig = cfg.extraConfig;
      aliases = cfg.aliases;
    };
  };
}
