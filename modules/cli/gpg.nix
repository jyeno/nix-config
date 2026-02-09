{
  flake.modules.homeManager.cli-gpg = {
    programs.gpg = {
      enable = true;
      # homeDir = "${config.home.homeDirectory}/.gnupg";
      # mutableKeys = false;

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
