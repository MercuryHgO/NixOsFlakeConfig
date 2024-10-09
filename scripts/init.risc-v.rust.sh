cat <<RT > ./rust-toolchain.toml && cp ~/nix/flakes/rust_esp.nix ./flake.nix
[toolchain]
channel = "nightly-2023-11-14"
components = ["rust-src"]
targets = ["riscv32imc-unknown-none-elf"]
RT
