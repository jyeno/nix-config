{
  enable = false;
  overclock = true;
  config = {
    daemon = {
      log_level = "info";
      admin_groups = [
        "wheel"
        "sudo"
      ];
      disable_clocks_cleanup = false;
    };
    apply_settings_timer = 5;
    gpus = {
      "1002:73DF-1458:2331-0000:03:00.0" = {
        fan_control_enabled = false;
        # fan_control_settings = {
        #   mode = "curve";
        #   static_speed = 0.7075070821529745;
        #   temperature_key = "edge";
        #   interval_ms = 500;
        #   curve = {
        #     "40" = 0.2;
        #     "50" = 0.35;
        #     "60" = 0.5;
        #     "70" = 0.75;
        #     "80" = 1.0;
        #   };
        #   spindown_delay_ms = 5000;
        #   change_threshold = 2;
        # };
        power_cap = 174.0;
        performance_level = "auto";
      };
    };
  };
}
