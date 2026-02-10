{inputs, ...}: {
  flake.modules.homeManager.cli-tools = {
    config,
    lib,
    pkgs,
    ...
  }: {
    home = inputs.self.lib.mkIfPersistence config {
      persistence."${config.systemConstants.persistDir}" = {
        directories = let
          privateDir = dir: {
            directory = dir;
            mode = "0700";
          };
        in
          [
            ".local/state/wireplumber" # dont lose state of audio devices
            ".nixos"
            "Music" # TODO add mpd check
            (privateDir ".local/share/containers") # TODO check if docker or podman is installed
          ]
          ++ lib.optionals (lib.elem pkgs.fish config.home.packages) [
            (privateDir ".local/share/fish")
          ]
          ++ lib.optionals (lib.elem pkgs.gnupg config.home.packages) [
            (privateDir ".gnupg")
          ]
          ++ lib.optionals (lib.elem pkgs.sops config.home.packages) [
            (privateDir ".config/sops")
          ]
          ++ lib.optionals (lib.elem pkgs.pass config.home.packages) [
            (privateDir ".password-store")
          ]
          ++ lib.optionals (lib.elem pkgs.direnv config.home.packages) [
            (privateDir ".local/share/direnv")
          ]
          ++ lib.optionals (lib.elem pkgs.pass config.home.packages) [
            (privateDir ".password-store")
          ];
        files = [
          ".ssh/known_hosts"
          ".Passwords.kdbx"
        ];
      };
    };
  };
}
