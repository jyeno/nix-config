{
  flake.modules.nixos.services-minidlna =
    { lib, ... }:
    {
      # Enable minidlna (ReadyMedia)
      services.minidlna = {
        enable = true;
        openFirewall = true;
        settings = {
          inotify = "yes";
          friendly_name = "torrent stream";
          media_dir = lib.mkDefault [
            "V,/data/torrent" # Add your video directories
          ];
        };
      };
    };
}
