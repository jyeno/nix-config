{inputs, ...}: {
  flake.modules.nixos.nirvana-todo = {
    # TODO check if disko not error out on boot
    imports = with inputs.self.modules.nixos; [
      disko
    ];

    disko.devices = {
      disk.main = {
        device = "/dev/sda";
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
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/";
                mountOptions = [
                  "defaults"
                  "noatime"
                  "nodev"
                  "logbufs=8"
                  "logbsize=256k"
                  "largeio"
                  "inode64"
                  "swalloc"
                  "allocsize=131072k"
                ];
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
            "size=4G"
            "noatime"
            "defaults"
          ];
        };
      };
    };
  };
}
