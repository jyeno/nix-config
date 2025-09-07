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
    enableNeorg = lib.mkEnableOption "Enable neorg plugin" // {default = true;};
    vimAlias = lib.mkEnableOption "Enable vim and vi aliases" // {default = true;};
    enableTreesitter = lib.mkEnableOption "Enable treesitter integration" // {default = true;};
    enableFormat = lib.mkEnableOption "Enable format files" // {default = true;};
    enableUndoFile = lib.mkEnableOption "Enable undofile" // {default = true;};
    lsp = lib.mkEnableOption "Enable lsp integration" // {default = true;};
    languages = lib.mkOption {
      type = lib.types.attrs;
      default = {
        nix.enable = true;
        zig.enable = true;
        clang.enable = true;
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
      description = "nvf languages configuration";
    };
    options = lib.mkOption {
      type = lib.types.attrs;
      default = {
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
      description = "nvf options configuration";
    };
    luaConfig = lib.mkOption {
      type = lib.types.str;
      default = ''
        -- remove whitespace on save
        vim.cmd([[au BufWritePre * :%s/\s\+$//e]])

        -- 2 spaces for selected filetypes
        vim.cmd([[
          autocmd FileType xml,nix,html,xhtml,css,scss,javascript,lua,yaml,sh,bash setlocal shiftwidth=2 tabstop=2
        ]])
      '';
      description = "nvf lua str config";
    };
    startPlugins = lib.mkOption {
      type = with lib.types; listOf packages;
      default = with pkgs.vimPlugins; [
        vim-gitgutter
        vim-vinegar
        nvim-surround
        vim-commentary
      ];
      description = "list of startup plugins";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          viAlias = cfg.vimAlias;
          vimAlias = cfg.vimAlias;
          lsp.enable = cfg.enableLsp;

          statusline.lualine.enable = true;

          telescope.enable = lib.mkDefault true;
          autocomplete.nvim-cmp.enable = lib.mkDefault true;
          git.enable = lib.mkDefault true; # git-signs, vim-fugitive, git-conflict

          notes.neorg = {
            enable = cfg.neorg;
            treesitter.enable = cfg.enableTreesitter;
          };

          languages =
            {
              enableTreesitter = cfg.enableTreesitter;
              enableFormat = cfg.enableFormat;
            }
            // cfg.languages;

          startPlugins = cfg.startPlugins;

          undoFile.enable = cfg.enableUndoFile;
          options = cfg.options;
          luaConfigRC.myconfig = cfg.luaConfig;
        };
      };
    };
  };
}
