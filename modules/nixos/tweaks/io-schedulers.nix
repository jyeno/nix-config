{
  config,
  lib,
  ...
}: let
  cfg = config.local.tweaks.io-schedulers;
in {
  options.local.tweaks.io-schedulers.enable = lib.mkEnableOption "Enable I/O scheduler configuration";
  config = lib.mkIf cfg.enable {
    services.udev.extraRules = ''
      ACTION=="add|change",
      KERNEL=="sd[a-z][a-z]*",
      ATTR{queue/rotational}!="0",
      ATTR{queue/scheduler}="bfq"
      ACTION=="add|change",
      KERNEL=="sd[a-z][a-z]*|mmcblk[0-9][0-9]*",
      ATTR{queue/rotational}=="0",
      ATTR{queue/scheduler}="mq-deadline"
      ACTION=="add|change",
      KERNEL=="nvme[0-9][0-9]*n[0-9][0-9]*",
      ATTR{queue/scheduler}="none"
    '';
  };
}
