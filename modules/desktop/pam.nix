{
  flake.modules.nixos.desktop-pam = {
    security.pam.services = {
      waylock = { };
      hyprlock = { };
    };
  };
}
