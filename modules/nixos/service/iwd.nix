{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.service.iwd;
in {
  # TODO figure out what to do with sops
  options.local.service.iwd = {
    enable = lib.mkEnableOption "Enable IWD configuration";
    sopsPopulateNetworks = lib.mkEnableOption "Populate IWD networks on boot (handy with a impermanence setup)";
  };
  config = lib.mkIf cfg.enable {
    networking.wireless.iwd = {
      enable = lib.mkDefault true;
      settings = {
        General.EnableNetworkConfiguration = true;
        IPv6.Enabled = true;
        settings = {
          Autoconnect = true;
        };
      };
    };
    # // lib.mkIf cfg.sopsPopulateNetworks {
    sops.secrets."wireless.env" = {};

    systemd.services.impermanenceIwdNetworks = {
      description = "Generate IWD network configuration for impermanence setup";
      wantedBy = ["multi-user.target"];
      before = ["iwd.service"];
      serviceConfig = {
        # TODO fix enconding
        ExecStart = pkgs.writeScript "gen_networks.sh" ''
          #!${pkgs.bash}/bin/bash
          set -euo pipefail
          BASE_DIR=/var/lib/iwd/

          # Parse environment file and collect values
          VALUES=$(${pkgs.gawk}/bin/awk -F'=' '{
            # Remove leading/trailing whitespace from value
            gsub(/^[ \t]+|[ \t]+$/, "_", $2)
            # Remove surrounding quotes if present
            gsub(/^"|"$/, "", $2)
            print $2
          }' ${config.sops.secrets."wireless.env".path})

          # Convert the values into an array
          readarray -t PARSED_VALUES <<< "$VALUES"

          mkdir -p -m 700 /var/lib/iwd
          for ((i=0; i < "''${#PARSED_VALUES[@]}"; i+=2)); do
            printf "[Security]\nPassphrase=''${PARSED_VALUES[''$((i + 1))]}\n\n[Settings]\nAutoConnect=true" > $BASE_DIR/''${PARSED_VALUES[$i]}.psk
          done
        '';
        Type = "oneshot";
        EnvironmentFile = config.sops.secrets."wireless.env".path;
      };
    };
  };
  # };
}
