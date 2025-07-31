{
  config,
  lib,
  ...
}: let
  cfg = config.local.home.cli.ssh;
in {
  options.local.home.cli.ssh = {
    enable = lib.mkEnableOption "Enable SSH user configuration";
  };
  config = lib.mkIf cfg.enable {
    # TODO add more options
    home.file.".ssh/id_ed25519.pub".source = ../../../extras/pubkeys/id_jyeno.pub;

    services.ssh-agent.enable = true;

    programs.ssh = {
      enable = true;
      addKeysToAgent = "1h";
      matchBlocks = {
        "openwrt" = {
          hostname = "192.168.1.0";
          user = "root";
        };
        "alph" = {
          hostname = "192.168.0.248";
          user = "root";
        };
      };
    };
  };
}
