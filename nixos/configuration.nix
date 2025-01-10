# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, secrets, ... }:
let
  systemPackages = import ./system-packages.nix {inherit pkgs inputs;};
  secrets = import ./secrets.nix;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    openssh = {
      enable = true;
      allowSFTP = true;
      settings = {
        Macs = [
        "hmac-sha2-512"
        "hmac-sha2-256"
        # "umac-128"  
        ];
      };
    };


    xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = false;
      };
      # displayManager.sddm = {
      #   enable = true;
      #   # wayland = false;
      # };
      desktopManager.gnome.enable = true;
      # desktopManager.kde5.enable = true;
      videoDrivers = ["nvidia"];
    };
    gnome.gnome-remote-desktop.enable = true;

  };
  
  fileSystems = {
    "/mnt" = {
      device = "/dev/disk/by-uuid/38ce5e64-fe03-49cb-8c74-703ffecf24b0";
      fsType = "ext4";
    };
  };

  # systemd.services = {
  #   spoof-dpi = {
  #     enable = true;
  #     serviceConfig = {
  #       ExecStart = "${spoof-dpi}/bin/spoofdpi";
  #     };
  #   };
  # };

  stylix = {
    enable = true;
    image = ./wallpaper.jpg;
    polarity = "dark";

    targets.gtk.enable = true;

    base16Scheme = {
      base00 = "110903";
      base01 = "330000";
      base02 = "2f1f13";
      base03 = "b36624";
      base04 = "eab15e";
      base05 = "ff8400";
      base06 = "e69532";
      base07 = "c9bf28";
      

      # base00 = "2b0700";
      # base01 = "bd350f";
      # base02 = "913412";
      # base03 = "8c5d2b";
      # base04 = "8f491f";
      # base05 = "f17755";
      # base06 = "e8b99b";
      # base07 = "bd350f";

      base08 = "e06c75";
      base09 = "d19a66";
      base0A = "e5c07b";
      base0B = "98c379";
      base0C = "56b6c2";
      base0D = "61afef";
      base0E = "c678dd";
      base0F = "be5046";
    };

    cursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  networking = {
    firewall = {
      enable = true;

      allowedTCPPorts = [ 80 443 9000 22 5900 3390 3389 ];
      allowedUDPPorts = [ 33221 3390 3389 ];

      allowedUDPPortRanges = [
        { from = 1716; to = 1764; } # KDE Connect
        { from = 9000; to = 9020; } # Debug ports
      ];
      allowedTCPPortRanges = [
        { from = 1716; to = 1764; } # KDE Connect
        { from = 9000; to = 9020; } # Debug ports
      ];
    };

    wg-quick.interfaces = {
      wg0 = {
        address = [ "10.100.0.3/24" ];
        dns = [ "8.8.8.8" ];
        # privateKeyFile = "/home/bittermann/nix/nixos/private";
        privateKey = secrets.wg-quick.privateKey;
        peers = [
          {
            publicKey = "eEWgilzJBr2z3odHDgKfUAbiT4XlQlFUzIoHscNHZUs=";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = secrets.wg-quick.vpsIp + ":33221";
            persistentKeepalive = 25;
          }
        ];

        # postUp = ''
        #   ${pkgs.iptables}/bin/iptables -A INPUT -s 195.211.245.50 -j ACCEPT
        #   ${pkgs.iptables}/bin/iptables -A INPUT -s 10.100.0.0/24 -j ACCEPT

        #   # ${pkgs.iptables}/bin/iptables -A INPUT -s 195.211.245.50 -j DROP
        # '';
        # postDown = ''
        #   ${pkgs.iptables}/bin/iptables -D INPUT -s 195.211.245.50 -j ACCEPT
        #   ${pkgs.iptables}/bin/iptables -D INPUT -s 10.100.0.0/24 -j ACCEPT

        #   # ${pkgs.iptables}/bin/iptables -D INPUT -s 195.211.245.50 -j DROP
        # '';
      };
    };
  };
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        # efiInstallAsRemovable = true;
        useOSProber = true;
      };
    };

    supportedFilesystems = [ "ntfs" ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Moscow";

  environment.sessionVariables = rec {
    EDITOR = "hx";
    SCRIPTS = "$HOME/nix/scripts";
    PATH = [
      "${SCRIPTS}"
    ];
  };

  hardware = {
    nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
      nvidiaSettings = true;
      # powerManagement.enable = true;
    };
    pulseaudio = {
      enable = false;
    };
    graphics = {
      enable = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      nvidia.acceptLicense = true;
    };
  };

  virtualisation = {
    libvirtd = {
      enable = true;
    };
    docker = {
      enable = true;
      storageDriver = "btrfs";
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gedit
  ]) ++ (with pkgs; [
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
    programs = {

      firefox = {
        enable = true;
      };

      kitty = {
        enable = true;
        extraConfig = ''
          background_opacity 0.7
          dynamic_background_opacity yes
          hide_window_decorations yes
        '';
      };

      tmux = {
        enable = true;
        clock24 = false;
        extraConfig = ''
          set-option -g prefix C-a
          unbind C-b
          set -sg escape-time 0
          set-option -g default-shell /run/current-system/sw/bin/bash
        '';
      };

      helix = {
        enable = true;
        settings = {
          editor = {
            line-number = "relative";
            lsp = {
              display-messages = true;
              display-inlay-hints = true;
              enable = true;
            };

            indent-guides = {
              render = true;
              character = "┊";
              skip-levels = 1;
            };
          };
        };
        languages = {
          language-server = {
            ccls = {
              command = "ccls";
            };
            nixd = {
              command = "nixd";
            };
            nil = {
              command = "nil";
            };
            typescript-language-server = {
              command = "typescript-language-server";
            };
            emmet-lsp = {
              command = "emmet-language-server";
              args = ["--stdio"];
            };
            deno = {
              command = "deno";
              args = ["lsp"];
              config.deno = {
                enable = true;
                lint = true;
                inlayHints = {
                  parameterNames.enabled = "all";
                  parameterTypes.enabled = true;
                  variableTypes.enabled = true;
                  propertyDeclarationTypes.enabled  = true;
                  functionLikeReturnTypes.enabled = true;
                  enumMemberValues.enabled = true;
                };
                suggest.imports.hosts = { "https://deno.land" = true; };
                importMap = "deno.json";
              };
            };
            rust-analyzer = {
              command = "rust-analyzer";
              config = {
                inlayHints = {
                  bindingModeHints.enable = false;
                  closingBraceHints.minLines = 10;
                  closureReturnTypeHints.enable = "with_block";
                  discriminantHints.enable = "fieldless";
                  lifetimeElisionHints.enable = "skip_trivial";
                  typeHints.hideClosureInitialization = false;
                };
              };
            };
          };

          grammar = [
            {
              name = "tsx";
              source = {
                 git = "https://github.com/tree-sitter/tree-sitter-typescript";
                 rev = "b1bf4825d9eaa0f3bdeb1e52f099533328acfbdf";
                 subpath = "tsx";
              };
            }
            {
              name = "dockerfile";
              source = {
                git = "https://github.com/camdencheek/tree-sitter-dockerfile";
                rev = "087daa20438a6cc01fa5e6fe6906d77c869d19fe";
              };
            }
          ];
    
          language = [
            {
              name = "tsx";
               scope = "source.tsx";
               injection-regex = "(tsx)";
               language-id = "typescriptreact";
               file-types = ["tsx"];
               comment-token = "//";
               block-comment-tokens = { start = "/*"; end = "*/"; };
               language-servers = [ "typescript-language-server" "emmet-lsp" "deno"];
               indent = { tab-width = 2; unit = "  "; };
            }
            {
              name = "typescript";
              file-types = ["ts"];
              language-servers = [ "deno" ];
            }
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

            {
              name = "cpp";
              file-types = [
                "cpp"
                "c"
                "h"
                "hpp"
              ];
            }

            {
              name = "nix";
              language-servers = [
                "nixd"
                "nil"
              ];
            }
          ];
         };

      };
    };
    home.stateVersion = "24.05";
  };

  # Fixes some shit with already existing gtk-3/4.0 configs
  home-manager.backupFileExtension = "backup";

  environment.systemPackages = systemPackages;

  system.stateVersion = "24.05"; # Did you read the comment?
}

