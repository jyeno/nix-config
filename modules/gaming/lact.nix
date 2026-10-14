{
  flake.modules.nixos.gaming-lact = {
    hardware.amdgpu.overdrive.enable = true;
    services.lact = {
      enable = true;
      settings = {
        version = 7;
        daemon = {
          log_level = "info";
          admin_groups = [
            "wheel"
          ];
          disable_clocks_cleanup = false;
        };
        current_profile = null;
        auto_switch_profiles = false;
        apply_settings_timer = 5;
        gpus = {
          "1002:73DF-1458:2331-0000:03:00.0" = {
            fan_control_enabled = false;
            power_cap = 186.0;
            performance_level = "auto";
            min_core_clock = 2400;
            max_core_clock = 2600;
            # min_memory_clock = 674;
            # max_memory_clock = 1056;
            voltage_offset = -30;
          };
        };
      };
    };
  };
}
