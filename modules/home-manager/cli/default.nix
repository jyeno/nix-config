{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.home.cli;
in {
  options.local.home.cli = {
    aria2.enable = lib.mkEnableOption "Enable aria2";
    bat.enable = lib.mkEnableOption "Enable bat";
    fzf.enable = lib.mkEnableOption "Enable fzf";
    fd.enable = lib.mkEnableOption "Enable fd";
    browserpass = {
      enable = lib.mkEnableOption "Enable browserpass integration";
      browsers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["firefox" "chromium"];
        description = "List of browsers to integrate with";
      };
    };
    playerctl.enable = lib.mkEnableOption "Enable playerctl";
    mpv = {
      enable = lib.mkEnableOption "Enable mpv";
      scripts = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = with pkgs.mpvScripts; [
          mpris
          webtorrent-mpv-hook
        ];
        description = "List of mpv scripts";
      };
    };
    yt-dlp = {
      enable = lib.mkEnableOption "Enable yt-dlp";
      settings = lib.mkOption {
        type = lib.types.attrs;
        default = {
          embed-thumbnail = true;
          embed-subs = true;
          sub-langs = "all";
          yes-playlist = true;
          downloader = "aria2c";
          downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
        };
        description = "yt-dlp settings";
      };
    };
    pass = {
      enable = lib.mkEnableOption "Enable password-store";
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.pass.withExtensions (exts: [
          exts.pass-otp
          exts.pass-file
          exts.pass-audit
          exts.pass-update
          exts.pass-import
        ]);
        description = "password-store package setup";
      };
    };
    pass-secret-service.enable = lib.mkEnableOption "Enable pass secret service";
    direnv.enable = lib.mkEnableOption "Enable direnv";
  };

  imports = [
    ./fish.nix
    ./git.nix
    ./gpg.nix
    ./mpd.nix
    ./neomutt.nix
    ./neovim.nix
    ./newsboat.nix
    ./nvf.nix
    ./ssh.nix
    ./tmux.nix
  ];

  config.programs.aria2.enable = cfg.aria2.enable;

  config.programs.bat.enable = cfg.bat.enable;

  config.programs.fzf.enable = cfg.fzf.enable;

  config.programs.fd.enable = cfg.fd.enable;

  config.programs.browserpass = {
    enable = cfg.browserpass.enable;
    browsers = cfg.browserpass.browsers;
  };

  config.services.playerctld.enable = cfg.playerctl.enable;

  config.programs.mpv = {
    enable = cfg.mpv.enable;
    scripts = cfg.mpv.scripts;
  };

  config.programs.yt-dlp = {
    enable = cfg.yt-dlp.enable;
    settings = cfg.yt-dlp.settings;
  };

  config.programs.password-store = {
    enable = cfg.pass.enable;
    package = cfg.pass.package;
  };
  config.services.pass-secret-service.enable = cfg.pass-secret-service.enable;

  config.programs.direnv = {
    enable = cfg.direnv.enable;
    nix-direnv.enable = lib.mkDefault true;
  };
}
