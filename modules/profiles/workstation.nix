{ config, lib, pkgs, ... }:

# Workstation feature set: no battery management, performance-oriented
# defaults, multi-monitor friendly. Imported by desktop hosts.

{
  # Performance governor — desktops are plugged in, no reason to throttle.
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # Workstations get firmware updates too (motherboard, NIC, etc.).
  services.fwupd.enable = true;

  # Higher swappiness fine; no thermal concerns. Default kernel tuning.

  # Common workstation extras.
  environment.systemPackages = with pkgs; [
    pciutils
    usbutils
    lm_sensors
  ];

  # Multi-monitor: Hyprland config in home/hyprland.nix uses `,preferred`
  # for monitor matching by default. Per-host overrides go in the host's
  # default.nix if specific monitor layouts are needed.
}
