{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.gaming;
in {
  options.local.gaming = {
    enable = lib.mkEnableOption "Enable gaming environment configuration";
    settings = {
      hdr.enable = lib.mkEnableOption "Enable High Definition Range (HDR) support";
      rt = {
        enable = lib.mkEnableOption "Enable soft realtime priority (RT) support";
        optimize = lib.mkOption {
          type = lib.types.bool;
          default = cfg.settings.rt.enable;
          defaultText = lib.literalExpression "config.local.gaming.settings.rt.enable";
          description = "Enable kernel optimizations for soft RT";
        };
      };
      vrr.enable = lib.mkEnableOption "Enable Variable Refresh Rate (VRR) support";
      mangohud = {
        enable = lib.mkEnableOption "Enable MangoHud configuration";
        configStr = lib.mkOption {
          type = lib.types.str;
          default = "full,core_load=0";
          description = "Mangohud config flags";
        };
      };
      vkbasalt.enable = lib.mkEnableOption "Enable vkBasalt configuration";
      ntsync.enable = lib.mkEnableOption "Enable usage ntsync configuration"; #TODO add ntsync enablement in the config if possible
      wayland.enable = lib.mkEnableOption "Enable proton wayland support";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      (lib.optionals cfg.settings.mangohud.enable [pkgs.mangohud])
      ++ (lib.optionals cfg.settings.hdr.enable [pkgs.gamescope-wsi])
      ++ (lib.optionals cfg.settings.vkbasalt.enable [pkgs.vkbasalt]);

    chaotic.hdr.enable = cfg.settings.hdr.enable;

    systemd.tmpfiles.rules = lib.mkIf cfg.settings.rt.enable [
      "w /proc/sys/kernel/sched_autogroup_enabled - - - - 1"
      "w /proc/sys/kernel/sched_cfs_bandwidth_slice_us - - - - 3000"
      "w /proc/sys/kernel/sched_child_runs_first - - - - 0"
      "w /proc/sys/vm/compaction_proactiveness - - - - 0"
      "w /proc/sys/vm/min_free_kbytes - - - - 1048576"
      "w /proc/sys/vm/page_lock_unfairness - - - - 1"
      "w /proc/sys/vm/swappiness - - - - 10"
      "w /proc/sys/vm/watermark_boost_factor - - - - 1"
      "w /proc/sys/vm/watermark_scale_factor - - - - 500"
      "w /proc/sys/vm/zone_reclaim_mode - - - - 0"
      "w /sys/kernel/debug/sched/base_slice_ns  - - - - 3000000"
      "w /sys/kernel/debug/sched/migration_cost_ns - - - - 500000"
      "w /sys/kernel/debug/sched/nr_migrate - - - - 8"
      "w /sys/kernel/mm/lru_gen/enabled - - - - 5"
      "w /sys/kernel/mm/transparent_hugepage/defrag - - - - never"
      "w /sys/kernel/mm/transparent_hugepage/enabled - - - - madvise"
      "w /sys/kernel/mm/transparent_hugepage/shmem_enabled - - - - advise"
    ];
  };

  imports = [
    ./gamemode.nix
    ./gamescope.nix
    ./lact.nix
    ./steam.nix
  ];
}
