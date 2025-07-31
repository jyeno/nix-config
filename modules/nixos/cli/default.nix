{
  config,
  lib,
  pkgs,
  localLib,
  ...
}: let
  cfg = config.local.cli;
in {
  imports = lib.attrsets.attrValues (localLib.discoverModules ./.);

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
    systemPackages = lib.mkOption {
      type = with lib.types; listOf packages;
      default = with pkgs; [
        neovim
        wget
        git
        gnumake
        curl
        libnotify
      ];
      description = "List of system-wide packages";
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

    programs.mtr.enable = cfg.mtr;

    programs.gnupg.agent = {
      enable = cfg.gnuAgent;
      enableSSHSupport = lib.mkDefault true;
    };

    users = {
      defaultUserShell = lib.mkIf cfg.fish.enable pkgs.fish;
      mutableUsers = lib.mkDefault false;
    };
  };
}
