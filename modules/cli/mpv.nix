{
  flake.modules.homeManager.cli-players =
    { pkgs, ... }:
    {
      programs = {
        yt-dlp = {
          enable = true;
          settings = {
            embed-thumbnail = true;
            embed-subs = true;
            sub-langs = "all";
            yes-playlist = true;
            downloader = "aria2c";
            downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
          };
        };
        mpv = {
          enable = true;
          scripts = with pkgs.mpvScripts; [
            mpris
          ];
        };
      };
      services.playerctld.enable = true;
    };
}
