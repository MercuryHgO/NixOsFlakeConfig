{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";

    home-manager =  {
        url = "github:nix-community/home-manager/release-24.05";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:MercuryHgO/stylix/release-24.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

   
  outputs = { self, nixpkgs, stylix, home-manager, firefox, ...}@inputs:

    let 
      system = "x86_64-linux";
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {

        specialArgs = {
          pkgs-stable = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            # overlays = [ moz_overlay ];
          };
          inherit inputs system;
        };

        modules = [
          ./nixos/configuration.nix
          inputs.stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
        ];

      };

    };
}
