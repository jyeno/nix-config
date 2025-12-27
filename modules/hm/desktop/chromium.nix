{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.home.desktop.chromium;
in {
  options.local.home.desktop.chromium = {
    enable = lib.mkEnableOption "Enable chromium configuration";
    # TODO add extensions downloader based on the id and version specificied
    cmdArgs = {
      type = lib.types.listOf lib.types.str;
      default = [
        "--enable-features=AcceleratedVideoEncoder,WebUIDarkMode,AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoDecodeLinuxGL,VaapiIgnoreDriverChecks,webgpu,webgl2,rasterization,video_encode,video_decode,webgl,gpu_compositing,2d_canvas"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
        "--force-dark-mode"
      ];
      description = "chromium args setting";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.chromium = {
      enable = lib.mkDefault true;
      package = pkgs.ungoogled-chromium;
      # commandLineArgs = cfg.cmdArgs; #TODO figure out why it errors out
      commandLineArgs = [
        "--enable-features=AcceleratedVideoEncoder,WebUIDarkMode,AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoDecodeLinuxGL,VaapiIgnoreDriverChecks,webgpu,webgl2,rasterization,video_encode,video_decode,webgl,gpu_compositing,2d_canvas"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
        "--force-dark-mode"
      ];
      #TODO add script on git commit to download and update any plugin listed here
      #TODO add extensions option
      extensions = [
        {
          # ublock origin
          id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
          crxPath = ../../../extras/desktop/chromium_extensions/ublock_origin.crx;
          version = "1.62.0";
        }
        {
          # browser pass
          id = "naepdomgkenhinolocfifgehidddafch";
          crxPath = ../../../extras/desktop/chromium_extensions/browser_pass.crx;
          version = "3.9.0";
        }
        {
          # automa
          id = "infppggnoaenmfagbfknfkancpbljcca";
          crxPath = ../../../extras/desktop/chromium_extensions/automa.crx;
          version = "1.29.8";
        }
        {
          # augmented steam
          id = "dnhpnfgdlenaccegplpojghhmaamnnfp";
          crxPath = ../../../extras/desktop/chromium_extensions/augmented_steam.crx;
          version = "4.2.1";
        }
        {
          # tamper monkey
          id = "dhdgffkkebhmkfjojejmpbldmpobfkfo";
          crxPath = ../../../extras/desktop/chromium_extensions/tamper_monkey.crx;
          version = "5.3.3";
        }
        {
          # ttv lol pro
          id = "bpaoeijjlplfjbagceilcgbkcdjbomjd";
          crxPath = ../../../extras/desktop/chromium_extensions/ttv_lol_pro.crx;
          version = "2.4.0";
        }
        {
          # link map
          id = "jappgmhllahigjolfpgbjdfhciabdnde";
          crxPath = ../../../extras/desktop/chromium_extensions/link_map.crx;
          version = "1.1.7";
        }
        {
          # vimium
          id = "dbepggeogbaibhgnhhndojpepiihcmeb";
          crxPath = ../../../extras/desktop/chromium_extensions/vimium.crx;
          version = "2.2.0";
        }
        {
          # noscript
          id = "doojmbjmlfjjnbmnoijecmcbfeoakpjm";
          crxPath = ../../../extras/desktop/chromium_extensions/noscript.crx;
          version = "12.1.1";
        }
      ];
    };
  };
}
