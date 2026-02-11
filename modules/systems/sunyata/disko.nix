{inputs, ...}: {
  flake.modules.nixos.sunyata = {config, ...}: {
    imports = with inputs.self.modules.nixos; [
      disko
    ];

    disko.devices = {
      disk = {
        main = {
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
                  settings.allowDiscards = true;
                  content = {
                    type = "lvm_pv";
                    vg = "Neast";
                  };
                };
              };
            };
          };
        };
        bunk = {
          type = "disk";
          device = "/dev/sda";
          content = {
            type = "gpt";
            partitions = {
              misc = {
                size = "50G";
                content = {
                  type = "filesystem";
                  format = "ext4";
                };
              };
              datalvm = {
                size = "100%";
                content = {
                  type = "lvm_pv";
                  vg = "Bunk";
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
            "size=8G"
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
                  "${config.systemConstants.persistDir}" = {
                    mountOptions = ["subvol=persist" "compress=zstd" "noatime"];
                    mountpoint = "${config.systemConstants.persistDir}";
                  };
                };
              };
            };
          };
        };
        Bunk = {
          type = "lvm_vg";
          lvs = {
            data = {
              size = "20%FREE";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/data";
                mountOptions = ["noatime" "rw" "noexec"];
              };
            };

            games = {
              size = "70%%FREE";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/data/games";
                mountOptions = ["noatime" "rw"];
              };
            };
          };
        };
      };
    };
  };
}
