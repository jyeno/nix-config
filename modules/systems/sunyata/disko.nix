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
              persist = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "cryptPersist";
                  extraOpenArgs = [];
                  settings.allowDiscards = true;
                  content = {
                    type = "filesystem";
                    format = "xfs";
                    mountpoint = "${config.systemConstants.persistDir}";
                    mountOptions = [
                      "noatime"
                      "nodiratime"
                      "logbufs=8"
                      "logbsize=256k"
                    ];
                  };
                };
              };
              store = {
                size = "200G";
                content = {
                  type = "luks";
                  name = "cryptStore";
                  extraOpenArgs = [];
                  settings.allowDiscards = true;
                  content = {
                    type = "filesystem";
                    format = "xfs";
                    mountpoint = "/nix";
                    mountOptions = [
                      "noatime"
                      "nodiratime"
                      "logbufs=8"
                      "logbsize=256k"
                    ];
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
              data = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "xfs";
                  mountpoint = "/data";
                  mountOptions = ["noatime" "rw" "noexec"];
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
    };
  };
}
