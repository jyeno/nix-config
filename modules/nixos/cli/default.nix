{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.cli;
in {
  options.local.cli = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable cli root configuration";
    };
    consoleFont = lib.mkOption {
      type = lib.types.str;
      default = "Lat2-Terminus16";
      description = "Set console font";
    };
    mtr = lib.mkEnableOption "Enable MTR (traceroute) tooling";
    gnuAgent = lib.mkEnableOption "Enable GNU agent";
  };
  config = lib.mkIf cfg.enable {
    console = {
      font = cfg.consoleFont;
      useXkbConfig = lib.mkDefault true;
    };

    environment.variables.EDITOR = "nvim";
    environment.systemPackages = with pkgs; [
      # TODO put on an option
      neovim
      wget
      git
      gnumake
      curl
      libnotify
      wl-clipboard
    ];

    programs.mtr.enable = cfg.mtr;

    programs.gnupg.agent = {
      enable = cfg.gnuAgent;
      enableSSHSupport = lib.mkDefault true;
    };

    users.defaultUserShell = lib.mkIf cfg.fish.enable pkgs.fish;
    users.mutableUsers = lib.mkDefault false;
  };

  imports = [
    ./fish.nix
  ];
}
