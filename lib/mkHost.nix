# Helper: build a nixosSystem for one host with shared scaffolding.
#
# Each host invocation just lists its own extra modules (hardware module,
# hardware-configuration.nix, anything truly host-specific). Common modules
# live in modules/ and are wired in below.
#
# Usage from flake.nix:
#   nixosConfigurations.g14 = mkHost {
#     hostname = "g14";
#     extraModules = [
#       inputs.nixos-hardware.nixosModules.asus-zephyrus-ga403
#       ../modules/hardware/asus.nix
#       ../modules/hardware/nvidia-hybrid.nix
#       ../modules/profiles/laptop.nix
#     ];
#   };

{ inputs, system ? "x86_64-linux" }:

{ hostname, extraModules ? [] }:

inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs hostname; };

  modules = [
    # ── Common system layer ───────────────────────────────────────────
    ../modules/core.nix
    ../modules/audio.nix
    ../modules/bluetooth.nix
    ../modules/hyprland.nix
    ../modules/stylix.nix
    ../modules/packages.nix
    ../modules/yubikey.nix

    # ── Stylix ────────────────────────────────────────────────────────
    inputs.stylix.nixosModules.stylix

    # ── Hostname comes from the helper argument ───────────────────────
    { networking.hostName = hostname; }

    # ── Host's own configuration + extras ─────────────────────────────
    ../hosts/${hostname}

    # ── Home Manager wired in for every host ──────────────────────────
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "hm-bak";
      home-manager.extraSpecialArgs = { inherit inputs hostname; };
      home-manager.users.architect = import ../home;
    }
  ] ++ extraModules;
}
