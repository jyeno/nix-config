{
  flake.modules.homeManager.cli-git =
    { pkgs, ... }:
    {
      programs = {
        delta = {
          enable = true;
          enableGitIntegration = true;
          enableJujutsuIntegration = true;
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
        git = {
          enable = true;
          settings = {
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
        };
        # test
        jujutsu.enable = true;
      };
    };
}
