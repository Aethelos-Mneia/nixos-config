# PLACEHOLDER — replace with /etc/nixos/hardware-configuration.nix generated
# by the NixOS installer on grotto. The installer probes the actual disks,
# LUKS UUIDs, kernel modules, filesystems — none of which can be authored
# by hand without risking unbootable systems.

{ lib, ... }:

{
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
