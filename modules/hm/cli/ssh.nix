{
  config,
  lib,
  ...
}: let
  cfg = config.local.home.cli.ssh;
in {
  options.local.home.cli.ssh = {
    enable = lib.mkEnableOption "Enable SSH user configuration";
    matchBlocks = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "ssh matchBlocks";
    };
    ed25519Pubkey = lib.mkOption {
      type = with lib.types; str;
      default = "";
      description = "user ed25519 pubkey";
    };
    rsaPubkey = lib.mkOption {
      type = with lib.types; str;
      default = "";
      description = "user rsa pubkey";
    };
  };
  config = lib.mkIf cfg.enable {
    home.file.".ssh/id_ed25519.pub" = lib.mkIf (cfg.ed25519Pubkey != "") {
      text = cfg.ed25519Pubkey;
    };
    home.file.".ssh/id_rsa.pub" = lib.mkIf (cfg.rsaPubkey != "") {
      text = cfg.rsaPubkey;
    };

    services.ssh-agent.enable = true;

    programs.ssh = {
      enable = true;
      inherit (cfg) matchBlocks;
    };
  };
}
