{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.home.cli.fish;
in {
  options.local.home.cli.fish = {
    enable = lib.mkEnableOption "Enable fish shell configuration";
    aliases = lib.mkOption {
      type = lib.types.attrs;
      default = {
        grep = "rg --color=auto";
        cat = "bat --style=plain --paging=never";
        la = "eza -a --color=always --group-directories-first --grid --icons";
        ls = "eza -al --color=always --group-directories-first --grid --icons";
        ll = "eza -l --color=always --group-directories-first --octal-permissions --icons";
        lt = "eza -aT --color=always --group-directories-first --icons";
        tree = "eza -T --all --icons --git-ignore";
        s = "fzf";
        top = "${lib.getExe pkgs.btop}";
        ports = "${lib.getExe pkgs.unixtools.netstat} -tulanp";
        serve = "python -m http.server";
        nrs = "nixos-rebuild --ask-sudo-password switch --flake . &| ${lib.getExe pkgs.nix-output-monitor}";
        ttm = "${lib.getExe pkgs.tt} -quotes en";
        q = "exit";
      };
      description = "Fish aliases";
    };
    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = with pkgs.fishPlugins; [
        {
          name = "done";
          src = done.src;
        }
        {
          name = "fish-fzf";
          src = fzf-fish.src;
        }
        {
          name = "puffer";
          src = puffer.src;
        }
        {
          name = "autopair";
          src = autopair.src;
        }
        {
          name = "colored-man-pages";
          src = colored-man-pages.src;
        }
        {
          name = "async-prompt";
          src = pkgs.fetchFromGitHub {
            owner = "infused-kim";
            repo = "fish-async-prompt";
            rev = "07e107635e693734652b0709dd34166820f1e6ff";
            sha256 = "rE80IuJEqnqCIE93IzeT2Nder9j4fnhFEKx58HJUTPk=";
          };
        }
        {
          name = "refresh-prompt";
          src = pkgs.fetchFromGitHub {
            owner = "infused-kim";
            repo = "fish-refresh-prompt-on-cmd";
            rev = "8f01915193ea6ad3b3339f70554732bc392a6465";
            sha256 = "y0fX+tpMSG6uOYS0J9fplbZKKyiebqgTgC130LVHZGw=";
          };
        }
        {
          name = "z";
          src = z.src;
        }
      ];
      description = "Fish plugins setting";
    };
    interativeInit = lib.mkOption {
      type = lib.types.str;
      default = ''
        function 0x0
          for file in $argv
            curl -F file=@$file http://0x0.st
          end
        end

        function play
          if count $argv > /dev/null
            mpv --loop --ytdl-format=bestaudio ytdl://ytsearch:(echo $argv | tr ' ' '+')
          else
            mpv --loop --demuxer-max-bytes=1612Mib (wl-paste)
          end
        end

        function mkd
          mkdir -p $argv[1]
          cd $argv[1]
        end

        function fish_user_key_bindings
          fish_vi_key_bindings
        end

        function fish_right_prompt_loading_indicator
          echo (set_color '#aaa')' … '(set_color normal)
        end

        set fish_greeting
        set -g man_blink -o red
        set -g man_bold -o green
        set -g man_standout -b black 93a1a1
        set -g man_underline -u 93a1a1
      '';
      description = "Fish interative startup shell init script";
    };
    starship.enable = lib.mkEnableOption "Enable starship shell UI";
  };
  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = lib.mkDefault true;
      shellAliases = cfg.aliases;
      plugins = cfg.plugins;
      interactiveShellInit = cfg.interativeInit;
    };

    programs.nix-index.enableFishIntegration = true;

    # TODO add more options
    programs.starship = {
      enable = cfg.starship.enable;
      enableFishIntegration = lib.mkDefault true;
      enableTransience =  lib.mkDefault true;
      settings = {
        add_newline = false;

        character = {
          success_symbol = "[>](bold green)$username$directory(bold green)";
          vicmd_symbol = "[<](bold yellow)$username$directory(bold green)";
          vimcmd_visual_symbol = "[V<](bold yellow)$username$directory(bold green)";
          vimcmd_replace_symbol = "[C<](bold yellow)$username$directory(bold green)";
          error_symbol = "[>](bold red)$username$directory(bold red)";
        };

        shell = {
          disabled = false;
          format = "$indicator";
          fish_indicator = "(bright-white) ";
          bash_indicator = "(bright-white) ";
        };

        nix_shell = {
          symbol = "";
          format = "[$symbol]($style) ";
          style = "bright-purple bold";
        };
      };
    };
  };
}
