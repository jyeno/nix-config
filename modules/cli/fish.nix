{
  flake.modules.nixos.cli-fish = {
    programs.fish = {
      enable = true;
      vendor = {
        completions.enable = true;
        config.enable = true;
        functions.enable = true;
      };
    };
  };

  flake.modules.homeManager.cli-fish =
    { pkgs, ... }:
    {
      programs.fish = {
        enable = true;
        shellAliases = {
          grep = "rg --color=auto";
          cat = "bat --style=plain --paging=never";
          la = "eza -a --color=always --group-directories-first --grid --icons";
          ls = "eza -al --color=always --group-directories-first --grid --icons";
          ll = "eza -l --color=always --group-directories-first --octal-permissions --icons";
          lt = "eza -aT --color=always --group-directories-first --icons";
          tree = "eza -T --all --icons --git-ignore";
          s = "fzf";
          top = "${pkgs.lib.getExe pkgs.btop}";
          down = "aria2c (wl-paste)";
          ports = "${pkgs.lib.getExe pkgs.unixtools.netstat} -tulanp";
          serve = "python -m http.server";
          nrs = "nixos-rebuild --ask-sudo-password switch --flake . &| ${pkgs.lib.getExe pkgs.nix-output-monitor}";
          nrt = "nixos-rebuild --ask-sudo-password test --flake . &| ${pkgs.lib.getExe pkgs.nix-output-monitor}";
          npkgs = "nix search nixpkgs";
          ttm = "${pkgs.lib.getExe pkgs.tt} -quotes en";
          q = "exit";
        };
        plugins = with pkgs.fishPlugins; [
          {
            name = "done";
            inherit (done) src;
          }
          {
            name = "fish-fzf";
            inherit (fzf-fish) src;
          }
          {
            name = "puffer";
            inherit (puffer) src;
          }
          {
            name = "autopair";
            inherit (autopair) src;
          }
          {
            name = "colored-man-pages";
            inherit (colored-man-pages) src;
          }
          {
            name = "z";
            inherit (z) src;
          }
        ];
        interactiveShellInit = ''
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

          function nrun
            nix-shell -p $argv[1] --run "$argv[1] $argv[2..-1]"
          end

          function fish_user_key_bindings
            fish_vi_key_bindings
          end

          set fish_greeting
          set -g man_blink -o red
          set -g man_bold -o green
          set -g man_standout -b black 93a1a1
          set -g man_underline -u 93a1a1
        '';
      };
      programs.nix-index.enableFishIntegration = true;

      programs.starship = {
        enable = true;
        enableFishIntegration = true;
        enableTransience = true;
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
