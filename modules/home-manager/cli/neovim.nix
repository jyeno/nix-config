{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.home.cli.neovim;
in {
  options.local.home.cli.neovim = {
    enable = lib.mkEnableOption "Enable neovim (old) configuration";
  };
  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = lib.mkDefault true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        #clangd_extension-nvim
        zig-vim
        nvim-lspconfig
        lualine-nvim
        edge
        vim-fugitive
        nvim-lspconfig
        nvim-jdtls
        vim-gitgutter
        vim-vinegar
        nvim-surround
        vim-nix
        vim-commentary
      ];
      extraPackages = with pkgs; [
        qt6.qtdeclarative
      ];
      coc = {
        enable = true;
        package = pkgs.vimPlugins.nvim-lspconfig;
      };
      extraConfig = ''
        colorscheme edge
        set undofile
      '';
      extraLuaConfig = ''
        local o = vim.o
        local wo = vim.wo
        local bo = vim.bo

        -- globals options
        o.swapfile = true
        o.smartcase = true
        o.hlsearch = true
        o.incsearch = true
        o.ignorecase = true
        o.autoread = true
        -- o.foldmethod = "syntax"

        -- window-local options
        wo.number = true
        wo.relativenumber = true
        wo.breakindent = true
        wo.colorcolumn = '80'

        -- buffer-local options
        bo.undofile = true

        bo.expandtab = true      -- use spaces instead of tabs
        bo.shiftwidth = 4        -- shift 4 spaces when tab
        bo.softtabstop = 4
        bo.tabstop = 4           -- 1 tab == 4 spaces
        bo.smartindent = true    -- autoindent new lines

        bo.expandtab = true
        bo.swapfile = false

        local cmd = vim.cmd

        cmd(':command! WQ wq')
        cmd(':command! WQ wq')
        cmd(':command! Wq wq')
        cmd(':command! Wqa wqa')
        cmd(':command! W w')
        cmd(':command! Q q')

        -- remove whitespace on save
        cmd([[au BufWritePre * :%s/\s\+$//e]])

        -- 2 spaces for selected filetypes
        cmd([[
        autocmd FileType xml,nix,html,xhtml,css,scss,javascript,lua,yaml setlocal shiftwidth=2 tabstop=2
        ]])

        -- Mappings.
        local opts = { noremap=true, silent=true }

        require'lspconfig'.qmlls.setup{}
        require'lspconfig'.zls.setup{}
        require'lspconfig'.jdtls.setup{}

        require('lualine').setup {
          options = {
            theme = 'molokai',
            icons_enabled = true
          };
        }
      '';
    };
  };
}
