{
  inputs = {
    naersk.url = "github:nix-community/naersk/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, naersk }:
    utils.lib.eachDefaultSystem (system:
      let
        name = "test";

        pkgs = import nixpkgs { inherit system; };
        naersk-lib = pkgs.callPackage naersk { };

        # pkg-config-deps = with pkgs; [
        #   openssl
        # ];

        # pkg-config-path = builtins.concatStringsSep ":" (
        #   map (pkg: "${pkg.dev}/lib/pkgconfig") pkg-config-deps
        # );
      in
      {
        defaultPackage = naersk-lib.buildPackage {
          src = ./.;

          # nativeBuildInputs = with pkgs; [ ffmpeg ];
          # buildInputs = with pkgs; [ pkg-config ];

          # PKG_CONFIG_PATH = pkg-config-path;
        };

        devShell = pkgs.mkShell {
          buildInputs = with pkgs;[
            cargo
            rustc
            rustfmt
            pre-commit
            rustPackages.clippy
            rust-analyzer
          ];

          RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;


          shellHook = ''
            tmux new-session -d -t ${name}-dev 

            tmux split-window -h -t ${name}-dev
            tmux resize-pane -t ${name}-dev:0.1 -x 20%

            tmux send-keys -t ${name}-dev:0.0 'hx' C-m

            tmux attach-session -t ${name}-dev

            while tmux has-session -t ${name}-dev; do sleep 1; done
            exit
          '';

          # PKG_CONFIG_PATH = pkg-config-path;
        };
      }
    );
}
