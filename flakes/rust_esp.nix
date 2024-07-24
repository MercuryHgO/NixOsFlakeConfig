{
  description = "A very basic flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-23.05";
  inputs.rust-overlay = {
    url = "github:oxalica/rust-overlay";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    rust-overlay,
  }:
  let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      overlays = [(import rust-overlay)];
    };

    toolchain = (
      pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml
    );

  
    wokwi-cli = pkgs.stdenv.mkDerivation {
      name = "rust_esp";
      src = pkgs.fetchurl {
        url = "https://github.com/wokwi/wokwi-cli/releases/download/v0.12.0/wokwi-cli-linuxstatic-x64";
        sha256 = "sha256-c1Qmok7u3DppGx73FmHmbdcBXOd3wCH1IQ+ZjhAIBkc=";    
      };
      phases = ["installPhase"];
      installPhase = ''
        mkdir -p $out/bin
        cp $src $out/bin/wokwi-cli
        chmod +x $out/bin/wokwi-cli
      '';
    };
  in {
    devShells."x86_64-linux".default = pkgs.mkShell {
      name = "rust_esp";
      buildInputs = [
        pkgs.cargo-espflash
        pkgs.rust-analyzer
        toolchain
        wokwi-cli
        # (pkgs.writeScriptBin "wokwi-cli" ''
        #   #!${pkgs.stdenv.shell}
        #   exec ${pkgs.stdenv.shell} -c "${wokwi-cli}" --verbose
        # '')
      ];
      shellHook = ''
        export PS1="\n\[\033[1;34m\][\[\e]0;\u@rust_esp: \w\a\]\u@rust_esp:\w]\$\[\033[0m\] "
      '';
    };
  };
}
