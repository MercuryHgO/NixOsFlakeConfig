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
    image = ./wallpaper.png;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
    cursor = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
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
  boot.loader.grub.extraEntries = ''
    menuentry "Windows" {
      insmod part_gpt
      insmod fat
      insmod chain
      set root=(hd2,gpt2)
      chainloader /boot/EFI/Windows/bootmgfw.efi
    }
  '';
  # boot.loader.grub.extraFiles = ["/boot/EFI/Windows/bootmgfw.efi"];

  boot.supportedFilesystems = [ "ntfs" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Moscow";

  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

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
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  home-manager.users.bittermann = {
    programs.kitty = {
      enable = true;
      extraConfig = ''
        background_opacity 0.9
        dynamic_background_opacity yes
      '';
    };
    programs.helix.enable = true;
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

    firefox
    discord
    telegram-desktop

    tauon

    # markdown
    marksman
    
    # cpp
    clang
    clang-tools

    gnomeExtensions.unite
  ];

  system.stateVersion = "24.05"; # Did you read the comment?
}

