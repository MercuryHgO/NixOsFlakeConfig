{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
  };

  outputs = { self, nixpkgs }:
  let

    pkgs = import nixpkgs {
      system = "x86_64-linux";
    };
    
  in
  {

    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = [
        pkgs.vscode-langservers-extracted
      ];
    };

  };
}
