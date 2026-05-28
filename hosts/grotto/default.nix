# ─────────────────────────────────────────────────────────────────────────────
# grotto — workstation. All-AMD.
#
# Spec (as known so far):
#   CPU:  Ryzen 9 9700 (Zen 5)
#   GPU:  24GB AMD (most likely Radeon RX 7900 XTX — only consumer 24GB AMD)
#   RAM:  64GB ECC
#   No NVIDIA. No battery. No touchpad.
#
# Common modules come via lib/mkHost.nix. Hardware specifics here.
# ─────────────────────────────────────────────────────────────────────────────

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ECC memory monitoring — surface correctable/uncorrectable errors via
  # the EDAC subsystem. `rasdaemon` is the modern userspace daemon for it.
  hardware.cpu.amd.updateMicrocode = true;
  services.rasdaemon = {
    enable = true;
    record = true;          # logs events to sqlite DB at /var/lib/rasdaemon
  };

  # Workstation kernel — use the latest stable for newer hardware support.
  # Comment out if you want to stay on the default nixos kernel.
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  # Pin the state version we install under.
  system.stateVersion = "25.11";
}
