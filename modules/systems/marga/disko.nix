{inputs, ...}: {
  flake.modules.nixos.marga = {config, ...}: {
    imports = with inputs.self.modules.nixos; [
      disko
    ];

    disko.devices = {
      disk.main = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            esp = {
              name = "ESP";
              size = "1024M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["fmask=0022" "dmask=0022" "noatime" "defaults"];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                extraOpenArgs = [];
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "lvm_pv";
                  vg = "Neast";
                };
              };
            };
          };
        };
      };
      nodev = {
        "/" = {
          fsType = "tmpfs";
          mountOptions = [
            "mode=755"
            "size=2G"
            "noatime"
            "defaults"
          ];
        };
      };
      lvm_vg = {
        Neast = {
          type = "lvm_vg";
          lvs = {
            store = {
              size = "20%FREE";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/nix";
                mountOptions = ["defaults" "noatime"];
              };
            };
            sys = {
              size = "20%FREE";
              content = {
                type = "btrfs";
                extraArgs = ["-f"];

                subvolumes = {
                  "${config.systemConstants.persistDir}" = {
                    mountOptions = ["subvol=persist" "compress=zstd" "noatime"];
                    mountpoint = "${config.systemConstants.persistDir}";
                  };
                  "/home" = {
                    mountOptions = ["subvol=home" "compress=zstd" "noatime"];
                    mountpoint = "${config.systemConstants.persistDir}/home";
                  };
                  "/games" = {
                    mountOptions = ["subvol=games" "compress=zstd" "noatime"];
                    mountpoint = "/home/games";
                  };
                  "/build" = {
                    mountOptions = ["subvol=build" "compress=zstd" "noatime"];
                    mountpoint = "/home/build";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
