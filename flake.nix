{
  description = "Jake's G14 NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    stylix = {
      url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, stylix, ... }@inputs:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.g14 = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          # Hardware profile for the 2024 Zephyrus G14 (GA403).
          # If this errors on first build, fall back to `asus-zephyrus-ga402`
          # (older model, broader support) until the ga403 module lands.
          nixos-hardware.nixosModules.asus-zephyrus-ga403

          stylix.nixosModules.stylix

          ./hosts/g14/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-bak";
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.architect = import ./home;
          }
        ];
      };
    };
}
