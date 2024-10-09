cat <<RT > ./rust-toolchain.toml && cp ~/nix/flakes/rust.nix ./flake.nix
[toolchain]
channel = "stable"
RT
