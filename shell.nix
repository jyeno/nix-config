{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    alejandra
    pre-commit
  ];
  shellHook = ''
    alejandra --version
  '';
}
