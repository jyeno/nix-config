{
  flake.modules.nixos.gaming-steam =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      programs.steam = {
        enable = true;
        package = pkgs.steam.override {
          extraEnv = {
            MANGOHUD = true;
            MANGOHUD_CONFIG = "full,core_load=0";
            ENABLE_VKBASALT = false;
            PROTON_USE_NTSYNC = true;
            # PROTON_USE_WOW64 = true;
            PROTON_ENABLE_HDR = true;
            PROTON_ENABLE_WAYLAND = true;
            PROTON_PREFER_SDL = true;
            SDL_AUDIODRIVER = "pipewire";
            SDL_VIDEODRIVER = "wayland";
            PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES = true; # temp
          };
        };
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = true;
        protontricks.enable = true;
        extraCompatPackages = [
          pkgs.proton-ge-bin
          (pkgs.callPackage (
            {
              lib,
              fetchurl,
              stdenvNoCC,
            }:
            let
              name = "proton-cachyos-bin";
              version = "11.0-20260601";
              title = "Proton-CachyOS";
              homepage = "https://github.com/CachyOS/proton-cachyos";
              release = "cachyos-${version}-slr";
              tarball = "proton-${release}-x86_64.tar.xz";
              hash = "sha256-N2bcB4voaFNlRpAyQ6NvDCw/tSwfC5tHXuIPV0+puZs=";
            in
            stdenvNoCC.mkDerivation {
              inherit name version;

              src = fetchurl {
                inherit hash;
                url = "${homepage}/releases/download/${release}/${tarball}";
              };

              buildCommand = ''
                mkdir -p $out/bin
                tar -C $out/bin --strip=1 -x -f $src
                sed -i -r 's|"proton-.*"|"${title}"|' $out/bin/compatibilitytool.vdf
              '';

              meta = with lib; {
                inherit homepage;
                description = "Compatibility tool for Steam Play based" + " on Wine and additional components";
                license = licenses.bsd3;
                platforms = [ "x86_64-linux" ];
              };
            }
          ) { })
        ];
      };
    };
}
