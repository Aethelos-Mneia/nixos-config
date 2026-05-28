# PLACEHOLDER — replace with /etc/nixos/hardware-configuration.nix generated
# by the NixOS installer (it's hardware-probed: UUIDs, LUKS device names,
# filesystem layout, kernel modules for actual installed hardware).
#
# Keeping a stub here so `nix flake check` / `nixos-rebuild build` against
# this repo on the live Pop machine doesn't error out before install.

{ lib, ... }:

{
  # Bootloader — systemd-boot for UEFI, simpler than GRUB.
  # The installer-generated file will set this too; safe to keep here as a
  # default but the real file takes precedence.
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # Stub filesystem so the placeholder evaluates. Replaced by the real
  # installer output post-install.
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
