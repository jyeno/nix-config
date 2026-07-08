{
  # Nix flake for "too much bleeding-edge" and unreleased packages
  # (e.g., mesa_git, linux_cachyos, firefox_nightly, sway_git, gamescope_git).
  # And experimental modules (e.g., HDR, duckdns).
  # https://github.com/chaotic-cx/nyx

  flake-file.inputs.chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
}
