{
  flake.modules.homeManager.cli-nvf = {
    programs.nvf.settings.vim = {
      languages = {
        enableTreesitter = true;
        enableFormat = true;
        enableDAP = false;
        enableExtraDiagnostics = true;
        nix = {
          enable = true;
          format.type = [ "nixfmt" ];
          extraDiagnostics = {
            enable = true;
            types = [
              "statix"
              "deadnix"
            ];
          };
        };
        zig.enable = true;
        # clang.enable = true;
        sql.enable = true;
        qml.enable = true;
        rust.enable = true;
        markdown = {
          enable = true;
          extensions.render-markdown-nvim.enable = true;
        };
        elixir.enable = true;
        java.enable = false;
      };
      debugger = {
        nvim-dap = {
          enable = true;
          ui = {
            enable = true;
            autoStart = true;
          };
          mappings = {
            continue = "<leader>dc";
            goDown = "<leader>dvi";
            goUp = "<leader>dvo";
            hover = "<leader>dh";
            restart = "<leader>dR";
            runLast = "<leader>d.";
            runToCursor = "<leader>dgk";
            stepBack = "<leader>dgk";
            stepInto = "<leader>dgo";
            stepOver = "<leader>dgj";
            terminate = "<leader>dq";
            toggleBreakpoint = "<leader>db";
            toggleDapUI = "<leader>du";
            toggleRepl = "<leader>dr";
          };
        };
      };
    };
  };
}
