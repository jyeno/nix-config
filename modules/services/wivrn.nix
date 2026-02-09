{
  flake.modules.nixos.services-wivrn = {pkgs, ...}: {
    services.wivrn = {
      enable = true;
      openFirewall = true;
      highPriority = true;
      # steam.importOXRRuntimes = lib.mkDefault true; # Sets ‘PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES’ system-wide
      defaultRuntime = true;
      autoStart = true;
      config = {
        enable = true;
        json = {
          bitrate = 100000000; # Mb/s
          encoders = [
            {
              encoder = "vaapi";
              codec = "h265";
              width = 1.0;
              height = 1.0;
              offset_x = 0.0;
              offset_y = 0.0;
            }
          ];
          application = [pkgs.wayvr];
        };
      };
    };
  };
}
