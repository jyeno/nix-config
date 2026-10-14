{
  flake.modules.homeManager.cli-ssh =
    {
      pkgs,
      config,
      ...
    }:
    let
      inherit (config.home) username;
      ed25519Pubkey = builtins.readFile ../../extras/pubkeys/id_${username}.pub;
      rsaPubkey = "";
    in
    {
      home.file.".ssh/id_ed25519.pub" = pkgs.lib.mkIf (ed25519Pubkey != "") {
        text = ed25519Pubkey;
      };
      home.file.".ssh/id_rsa.pub" = pkgs.lib.mkIf (rsaPubkey != "") {
        text = rsaPubkey;
      };

      services.ssh-agent.enable = true;

      programs.ssh = {
        enable = true;
        matchBlocks = {
          # TODO make it an option / get value from some place
          "*" = {
            addKeysToAgent = "4h";
          }; # TODO dont always include them
          openwrt = {
            hostname = "192.168.1.1";
            user = "root";
          };
          alph = {
            hostname = "192.168.1.248";
            user = "root";
          };
          nirvana = {
            hostname = "nirvana.jyeno.cc";
            user = "${username}";
          };
        };
      };
    };
}
