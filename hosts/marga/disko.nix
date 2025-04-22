{device ? throw "Set this to your disk device, e.g. /dev/sda", ...}: {
  disko.devices = {
    disk.main = {
      inherit device;
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
                "/persist" = {
                  mountOptions = ["subvol=persist" "compress=zstd" "noatime"];
                  mountpoint = "/persist";
                };
                "/home" = {
                  mountOptions = ["subvol=home" "compress=zstd" "noatime"];
                  mountpoint = "/persist/home";
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
}
