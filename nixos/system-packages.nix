{pkgs, inputs, ...}: with pkgs;
let
  dockerfile-language-server = buildNpmPackage rec {
    pname = "dockerfile-language-server-nodejs";
    version = "0.13.0";

    src = fetchFromGitHub {
      owner = "rcjsuen";
      repo = "dockerfile-language-server-nodejs";
      rev = "v${version}";
      hash = "sha256-xhb540hXATfSo+O+BAYt4VWOa6QHLzKHoi0qKrdBVjw=";
    };

    preBuild = ''
      npm run prepublishOnly
    '';

    npmDepsHash = "sha256-+u4AM6wzVMhfQisw/kcwg4u0rzrbbQeIIk6qBXUM+5I=";

    meta = {
      changelog = "https://github.com/rcjsuen/dockerfile-language-server-nodejs/blob/${src.rev}/CHANGELOG.md";
      description = "Language server for Dockerfiles powered by Node.js, TypeScript, and VSCode technologies";
      homepage = "https://github.com/rcjsuen/dockerfile-language-server-nodejs";
      license = lib.licenses.mit;
      mainProgram = "docker-langserver";
      maintainers = with lib.maintainers; [ rvolosatovs net-mist ];
    };
  };
in
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
  popcorntime
  vlc

  # markdown
  marksman
  obsidian
  pandoc
  texliveSmall
  
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
  dockerfile-language-server
  docker-compose-language-service
  
  # bash
  nodePackages.bash-language-server

  # nix
  nixd
  nil

  # gnome shit
  gnomeExtensions.unite
  gnomeExtensions.gsconnect

  gnome-tweaks

  ffmpeg
]

