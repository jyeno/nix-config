{
  config,
  lib,
  ...
}: let
  cfg = config.local.home.cli.gpg;
in {
  options.local.home.cli.gpg = {
    enable = lib.mkEnableOption "Enable gpg configuration";
  };
  config = lib.mkIf cfg.enable {
    # TODO add more options
    programs.gpg = {
      enable = lib.mkDefault true;
      # homeDir = "${config.home.homeDirectory}/.gnupg";
      mutableKeys = false;

      # TODO figure out a way to make it work
      # autoGenerateKey = {
      #   enable = true;
      #   nameReal = config.home.username;
      #   nameEmail = "${config.home.username}@protonmail.com"; # TODO fix to use a more correct value
      #   keyType = "RSA";
      #   keyLength = 4096;
      #   expireDate = "0"; # no expiration
      # };
    };
    # Optionally, expose the GPG key ID as an environment variable
    # environment.variables.GPG_ID = "${config.programs.gpg.autoGenerateKey.keyId}";

    # Ensure the GPG home directory has the correct permissions
    # systemd.tmpfiles.rules = [
    #   "d ${config.home.homeDirectory}/.gnupg 0700 gpg gpg -"
    # ];
  };
}
