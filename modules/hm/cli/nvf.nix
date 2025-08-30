{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.home.cli.nvf;
in {
  options.local.home.cli.nvf = {
    enable = lib.mkEnableOption "Enable NVF (neovim flake) configuration";
  };
  config = lib.mkIf cfg.enable {
    # TODO add more options
    programs.nvf = {
      enable = lib.mkDefault true;
      settings = {
        vim = {
          viAlias = true;
          vimAlias = true;
          lsp.enable = true;

          statusline.lualine.enable = true;

          telescope.enable = true;
          autocomplete.nvim-cmp.enable = true;
          git.enable = true; # git-signs, vim-fugitive, git-conflict

          notes.neorg = {
            enable = true;
            treesitter.enable = true;
          };

          languages = {
            enableTreesitter = true;
            enableFormat = true;

            nix.enable = true;
            zig.enable = true;
            clang.enable = true;
            sql.enable = true;
            qml.enable = true;
            rust.enable = true;
            markdown.enable = true;
            elixir.enable = true;
            java.enable = false;
          };

          startPlugins = with pkgs.vimPlugins; [
            vim-gitgutter
            vim-vinegar
            nvim-surround
            vim-commentary
          ];

          undoFile.enable = true;
          options = {
            shiftwidth = 4;
            softtabstop = 4;
            tabstop = 4;
            swapfile = true;
            expandtab = true;
            smartcase = true;
            smartindent = true;
            breakindent = true;
            colorcolumn = "80";
            hlsearch = true;
            incsearch = true;
            ignorecase = true;
            autoread = true;
          };
          luaConfigRC.myconfig =
            /*
            LUA
            */
            ''
              -- remove whitespace on save
              vim.cmd([[au BufWritePre * :%s/\s\+$//e]])

              -- 2 spaces for selected filetypes
              vim.cmd([[
                autocmd FileType xml,nix,html,xhtml,css,scss,javascript,lua,yaml,sh,bash setlocal shiftwidth=2 tabstop=2
                ]])
            '';
        };
      };
    };
  };
}
