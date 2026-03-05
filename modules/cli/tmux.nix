{
  flake.modules.homeManager.cli-tmux =
    { pkgs, ... }:
    {
      programs.tmux = {
        enable = true;
        prefix = "C-a";
        shell = "${pkgs.fish}/bin/fish";
        terminal = "tmux-256color";
        clock24 = true;
        historyLimit = 100000;
        keyMode = "vi";
        newSession = true;
        plugins = with pkgs.tmuxPlugins; [
          yank
        ];
      };
    };
}
