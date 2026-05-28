# ─────────────────────────────────────────────────────────────────────────────
# INSTALL SEQUENCE
#   1. Install base NixOS with the graphical installer (ext4 + LUKS).
#   2. After first boot, copy this whole repo into /etc/nixos/ (or anywhere).
#   3. REPLACE hardware-configuration.nix with the installer-generated one
#      at /etc/nixos/hardware-configuration.nix — that file is hardware-probed
#      and must not be authored by hand. The placeholder here exists only so
#      `nix flake check` doesn't choke before install.
#   4. `sudo nixos-rebuild switch --flake /path/to/repo#g14`
#   5. Reboot, log in as `architect`, Hyprland comes up themed.
# ─────────────────────────────────────────────────────────────────────────────

{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core.nix
    ../../modules/hardware.nix
    ../../modules/hyprland.nix
    ../../modules/stylix.nix
    ../../modules/packages.nix
  ];

  networking.hostName = "g14";

  # Pin the state version to the release we installed under. Don't change
  # this on upgrades — it controls migration defaults, not feature set.
  system.stateVersion = "25.11";
}
