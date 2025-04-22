{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.local.home.misc.persistent;
in {
  options.local.home.misc.persistent = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true; # use value from system impermanence enablement
      description = "Enable home persistent config";
    };
  };
  config = lib.mkIf cfg.enable {
    #TODO add more options, dont hardcode user
    home.persistence."/persist/home/jyeno" = {
      directories = [
        ".gnupg"
        "music"
        ".mozilla/firefox/jyeno"
        ".local/share/64Gram"
        ".local/share/direnv"
        ".config/pulse"
        ".config/sops"
        ".config/r2modman"
        ".config/r2modmanPlus-local"
        ".config/chromium"
        {
          directory = ".local/share/Steam";
          method = "symlink";
        }
        {
          directory = ".cache/lm-studio";
          method = "symlink";
        }
        ".password-store"
        # ".nixops"
        ".nixos"
        # ".local/share/keyrings"
        # ".local/share/direnv"
        # ".nix-defexpr"
      ];
      files = [
        ".local/share/fish/fish_history"
        ".ssh/known_hosts"
        ".Passwords.kdbx"
        "todo"
      ];
      allowOther = true;
    };
  };
}
