{
  flake.modules.nixos.anatta-emustation =
    {
      pkgs,
      ...
    }:
    {
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      # 3. Pacotes de Emulação e Jogos
      environment.systemPackages = with pkgs; [
        # EmulationStation (Frontend Visual)
        emulationstation

        # RetroArch customizado com os Cores instalados declarativamente
        (retroarch.override {
          cores = with libretro; [
            snes9x # Super Nintendo
            fceuimm # NES / Nintendinho
            genesis-plus-gx # Mega Drive / Sega Genesis
            mgba # Game Boy Advance
            gambatte # Game Boy / Game Boy Color
            beetle-psx-hw # PlayStation 1
          ];
        })
      ];

      # 4. Inicialização automática direto no EmulationStation (Opcional)
      # Caso queira que o Pi ligue direto como um console de videogame:
      services.xserver = {
        enable = true;
        desktopManager.runXfg = true; # Permite rodar apps direto sem uma DE pesada (XFCE/Gnome)
        displayManager.autoLogin = {
          enable = true;
          user = "jyeno"; # mude para o nome do seu usuário
        };
      };

      # Executa o EmulationStation assim que o servidor gráfico inicia
      services.xserver.displayManager.sessionCommands = ''
        exec ${pkgs.emulationstation}/bin/emulationstation
      '';
    };
}
