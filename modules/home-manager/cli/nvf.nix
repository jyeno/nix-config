{
  config,
  lib,
  inputs,
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
          theme = {
            enable = true;
            name = "catppuccin";
            style = "mocha";
          };
          viAlias = true;
          vimAlias = true;
          lsp = {
            enable = true;
          };

          statusline.lualine = {
            enable = true;
            theme = "molokai";
          };

          telescope.enable = true;
          autocomplete.nvim-cmp.enable = true;
          git.enable = true; # git-signs, vim-fugitive, git-conflict

          languages = {
            enableLSP = true;
            enableTreesitter = true;

            nix.enable = true;
            zig.enable = true;
            clang.enable = true;

            # custom lsps
            java = {
              lsp = {
                enable = true;
                package = ["jdt-language-server" "-data" "~/.cache/jdtls/workspace"];
              };
            };
            # qmlls = {
            #   lsp = {
            #     enable = true;
            #     package = [ "qmlls" ];
            #   };
            # };
          };

          startPlugins = with pkgs.vimPlugins; [
            vim-gitgutter
            vim-vinegar
            nvim-surround
            vim-commentary
          ];
          extraPackages = with pkgs; [
            jdt-language-server
            qt6.qtdeclarative
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
