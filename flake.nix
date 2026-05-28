{
  description = "Jake's NixOS configs — g14, grotto, thinkpad, main";

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
      mkHost = import ./lib/mkHost.nix { inherit inputs; };
    in {
      nixosConfigurations = {

        # ── g14 — Asus Zephyrus G14 (GA403UV, 2024) — laptop, AMD+NVIDIA hybrid
        # If asus-zephyrus-ga403 doesn't exist in nixos-hardware yet, fall back
        # to asus-zephyrus-ga402.
        g14 = mkHost {
          hostname = "g14";
          extraModules = [
            nixos-hardware.nixosModules.asus-zephyrus-ga403
            ./modules/hardware/asus.nix
            ./modules/hardware/nvidia-hybrid.nix
            ./modules/profiles/laptop.nix
          ];
        };

        # ── grotto — workstation, all-AMD (Ryzen 9 9700 + Radeon 24GB + 64GB ECC)
        grotto = mkHost {
          hostname = "grotto";
          extraModules = [
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-cpu-amd-pstate
            nixos-hardware.nixosModules.common-gpu-amd
            nixos-hardware.nixosModules.common-pc-ssd
            ./modules/hardware/amd-gpu.nix
            ./modules/profiles/workstation.nix
          ];
        };

        # ── thinkpad — laptop, model TBD
        # TODO at install: add nixos-hardware.nixosModules.lenovo-thinkpad-<model>
        # and the right GPU module (most modern thinkpads are intel iGPU, no
        # extra module needed; AMD models import ./modules/hardware/amd-gpu.nix).
        thinkpad = mkHost {
          hostname = "thinkpad";
          extraModules = [
            ./modules/profiles/laptop.nix
            # nixos-hardware.nixosModules.lenovo-thinkpad-XXX
            # ./modules/hardware/amd-gpu.nix   # uncomment if AMD model
          ];
        };

        # ── main — desktop, hardware TBD
        # TODO at install: pick hardware module + GPU module.
        main = mkHost {
          hostname = "main";
          extraModules = [
            ./modules/profiles/workstation.nix
            # ./modules/hardware/amd-gpu.nix
            # OR ./modules/hardware/nvidia-hybrid.nix (with bus IDs)
          ];
        };
      };
    };
}
