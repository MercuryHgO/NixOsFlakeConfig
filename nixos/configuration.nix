# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  stylix = {
    enable = true;
    image = ./wallpaper.jpg;
    polarity = "dark";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

    targets.gtk.enable = true;

    base16Scheme = {
      base00 = "170c04";
      base01 = "330000";
      base02 = "2f1f13";
      base03 = "b36624";
      base04 = "eab15e";
      base05 = "ff8400";
      base06 = "e69532";
      base07 = "c9bf28";
      base08 = "bf6300";
      base09 = "ecb536";
      base0A = "f1c232";
      base0B = "b35900";
      base0C = "eb9c24";
      base0D = "bb6c3b";
      base0E = "e65c17";
      base0F = "c9a005";
    };

    cursor = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    # efiInstallAsRemovable = true;
    useOSProber = true;
  };
  # boot.loader.grub.extraEntries = ''
  #   menuentry "Windows" {
  #     insmod part_gpt
  #     insmod fat
  #     insmod chain
  #     set root=(hd2,gpt2)
  #     chainloader /boot/EFI/Windows/bootmgfw.efi
  #   }
  # '';
  # # boot.loader.grub.extraFiles = ["/boot/EFI/Windows/bootmgfw.efi"];

  boot.supportedFilesystems = [ "ntfs" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Moscow";

  environment.variables = rec {
    EDITOR = "hx";
    SCRIPTS = "$HOME/nix/scripts";

    # PS1="\n\[\033[1;32m\][\[\e]0;\u@\h\a\]\w]\$\[\033[0m\]";

    PATH = [
      "${SCRIPTS}"
    ];
  };

  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      # videoDrivers = ["nvidia"];
    };
  };
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  virtualisation.waydroid.enable = true;


  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gedit
  ]) ++ (with pkgs.gnome; [
    gnome-music
    gnome-terminal
    epiphany
    geary
    evince
    gnome-characters
    totem
    tali
    iagno
    hitori
    atomix
  ]);


  users.users.bittermann = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker"]; # Enable ‘sudo’ for the user.
  };

  home-manager.users.bittermann = {
    programs.kitty = {
      enable = true;
      extraConfig = ''
        background_opacity 0.7
        dynamic_background_opacity yes
        hide_window_decorations yes
      '';
    };

    programs.helix = {
      enable = true;
      settings = {
        editor = {
          line-number = "relative";

          lsp.display-messages = true;
          lsp.display-inlay-hints = true;
          lsp.enable = true;

          indent-guides = {
            render = true;
            character = "┊";
            skip-levels = 1;
          };
        };

       
      };
      languages = {
        language-server = {
          rust-analyzer = {
            command = "rust-analyzer";
            config = {
              inlayHints.bindingModeHints.enable = false;
              inlayHints.closingBraceHints.minLines = 10;
              inlayHints.closureReturnTypeHints.enable = "with_block";
              inlayHints.discriminantHints.enable = "fieldless";
              inlayHints.lifetimeElisionHints.enable = "skip_trivial";
              inlayHints.typeHints.hideClosureInitialization = false;
            };
          };
        };

        language = [
          {
          name = "rust";
          auto-format = false;
            roots = [
              "Cargo.toml"
              "Cargo.lock"
            ];
          }

          {
          name = "bash";
          file-types = [
            "sh"
            "bash"
          ];
          }
        ];
       };
    };
    home.stateVersion = "24.05";
  };

  # Fixes some shit with already existing gtk-3/4.0 configs
  home-manager.backupFileExtension = "backup";

  environment.systemPackages = with pkgs; [
    home-manager


    base16-schemes

    kitty
    helix # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    transmission
    neofetch

    corefonts
    onlyoffice-bin

    firefox
    discord
    telegram-desktop

    tauon

    # markdown
    marksman
    
    # cpp
    clang
    clang-tools

    # rust
    rustup
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

    # gnome shit
    gnomeExtensions.unite

    gnome.gnome-tweaks
  ];

  system.stateVersion = "24.05"; # Did you read the comment?
}

