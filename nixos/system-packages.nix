{pkgs, inputs, ...}: with pkgs;
[
  home-manager

  base16-schemes

  kitty
  helix # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  wget
  git
  transmission
  neofetch
  tmux

  corefonts
  liberation_ttf
  onlyoffice-bin

  firefox
  webcord
  telegram-desktop

  tauon

  # markdown
  marksman
  
  # cpp
  # clang
  # clang-tools

  # rust
  # rustup
  # cargo
  # rustc
  # rust-analyzer

  # yaml
  yaml-language-server

  # docker
  docker-compose
  dockerfile-language-server-nodejs
  docker-compose-language-service
  
  # bash
  nodePackages.bash-language-server

  # nix
  nixd
  nil

  # gnome shit
  gnomeExtensions.unite
  gnomeExtensions.gsconnect

  gnome.gnome-tweaks

]

