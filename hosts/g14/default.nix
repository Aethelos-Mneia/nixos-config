# ─────────────────────────────────────────────────────────────────────────────
# Asus Zephyrus G14 (GA403UV, 2024) — laptop, hybrid AMD Phoenix3 + NVIDIA.
#
# Common modules (core, audio, bluetooth, hyprland, stylix, packages,
# yubikey, hostname, Stylix wiring, home-manager) come from lib/mkHost.nix.
# This file holds only what's truly host-specific.
#
# INSTALL: see the top-level README pattern — graphical installer → copy
# repo → replace hardware-configuration.nix with installer output →
# `sudo nixos-rebuild switch --flake .#g14`.
# ─────────────────────────────────────────────────────────────────────────────

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  # (asus, nvidia-hybrid, profiles/laptop are wired in flake.nix via
  #  extraModules so the host file stays purely about host-specific values.)

  # PCI bus IDs from this machine's lspci output:
  #   01:00.0 NVIDIA  → "PCI:1:0:0"
  #   65:00.0 AMD     → "PCI:101:0:0"   (0x65 = 101 decimal)
  hardware.nvidia.prime = {
    amdgpuBusId = "PCI:101:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # Pin the state version to the release we installed under. Don't change
  # this on upgrades — it controls migration defaults, not feature set.
  system.stateVersion = "25.11";
}
