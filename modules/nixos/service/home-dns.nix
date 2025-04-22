{
  config,
  lib,
  ...
}: let
  cfg = config.local.service.home-dns;
in {
  options.local.service.home-dns = {
    enable = lib.mkEnableOption "Enable DNS filter service";
    port = lib.mkOption {
      type = lib.types.int;
      default = 53;
      description = "Port number of the DNS service";
    };
    blacklistUrls = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
      description = "List of urls to add to blacklist";
    };
  };
  config = lib.mkIf cfg.enable {
    services.blocky = {
      # TODO add more options
      enable = lib.mkDefault true;
      settings = {
        ports.dns = cfg.port;
        upstreams.groups.default = [
          "https://one.one.one.one/dns-query"
        ];
        bootstrapDns = {
          upstream = "https://one.one.one.one/dns-query";
          ips = ["1.1.1.1" "1.0.0.1"];
        };
        blocking = {
          blackLists.ads = cfg.blacklistUrls;
          clientGroupsBlock = {
            default = ["ads"];
            kids-ipad = ["ads"];
          };
        };
      };
    };
  };
}
