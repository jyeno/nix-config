{ inputs, ... }:
{
  flake.modules.homeManager.cli-nvf =
    { pkgs, ... }:
    {
      imports = [ inputs.self.modules.homeManager.nvf ];
      programs.nvf = {
        enable = true;
        settings.vim = {
          viAlias = true;
          vimAlias = true;
          statusline.lualine.enable = true;

          telescope.enable = true;
          git.enable = true; # git-signs, vim-fugitive, git-conflict

          notes.neorg = {
            enable = true;
            treesitter.enable = true;
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
          terminal.toggleterm = {
            enable = true;
            mappings.open = "<C-t>";

            lazygit = {
              enable = true;
              mappings.open = "<leader>gg";
            };

            setupOpts = {
              open_mapping = "<C-t>";
              direction = "horizontal";
              winbar = {
                enabled = true;
                #name_formatter = "function(term) return 'Terminal #' .. term.id end";
              };
            };
          };
          luaConfigRC.myconfig = ''
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
}
