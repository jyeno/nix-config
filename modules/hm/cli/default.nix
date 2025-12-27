{
  config,
  lib,
  pkgs,
  localLib,
  ...
}: let
  cfg = config.local.home.cli;
in {
  imports = lib.attrsets.attrValues (localLib.discoverModules ./.);

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
  config.programs = {
    aria2 = lib.mkIf cfg.aria2.enable {
      enable = true;
    };
    bat = lib.mkIf cfg.bat.enable {
      enable = true;
    };
    fzf = lib.mkIf cfg.fzf.enable {
      enable = true;
    };
    fd = lib.mkIf cfg.fd.enable {
      enable = true;
    };
    browserpass = lib.mkIf cfg.browserpass.enable {
      enable = true;
      browsers = cfg.browserpass.browsers;
    };
    mpv = lib.mkIf cfg.mpv.enable {
      enable = true;
      scripts = cfg.mpv.scripts;
    };
    yt-dlp = lib.mkIf cfg.yt-dlp.enable {
      enable = true;
      settings = cfg.yt-dlp.settings;
    };
    password-store = lib.mkIf cfg.pass.enable {
      enable = true;
      package = cfg.pass.package;
    };
    direnv = lib.mkIf cfg.direnv.enable {
      enable = true;
      nix-direnv.enable = lib.mkDefault true;
    };
  };

  config.services = {
    pass-secret-service = lib.mkIf cfg.pass-secret-service.enable {
      enable = true;
    };
    playerctld = lib.mkIf cfg.playerctl.enable {
      enable = true;
    };
  };
}
