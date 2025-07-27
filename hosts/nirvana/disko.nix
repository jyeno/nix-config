{device ? "/dev/sda", ...}: {
  disko.devices = {
    disk.main = {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            name = "ESP";
            size = "600M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["fmask=0022" "dmask=0022" "noatime" "defaults"];
            };
          };
          yaksha = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = ["-f"]; # Override existing partition
              # Subvolumes must set a mountpoint in order to be mounted,
              # unless their parent is mounted
              subvolumes = {
                "/rootfs" = {
                  mountOptions = ["subvol=rootfs" "compress=zstd" "noatime"];
                  mountpoint = "/";
                };
                "/home" = {
                  mountOptions = ["subvol=home" "compress=zstd" "noatime"];
                  mountpoint = "/home";
                };
                "/nix" = {
                  mountOptions = ["subvol=nix" "compress=zstd" "noatime"];
                  mountpoint = "/nix";
                };
              };
            };
          };
        };
      };
    };
    nodev = {
      "/tmp" = {
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
}
