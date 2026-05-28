{ config, lib, pkgs, ... }:

{
  # Asus laptop tooling.
  #   asusd       — keyboard backlight, fan profiles, battery charge limit,
  #                  AniMe Matrix on G14, etc. Replaces what manufacturer
  #                  utilities do on Windows.
  #   supergfxctl — GPU mode switching (hybrid / integrated / dedicated).
  #                  Only meaningful on hybrid-GPU Asus models.
  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  services.supergfxd.enable = true;

  # asusd handles power profile management; turn off the generic daemon so
  # they don't fight over /sys writes.
  services.power-profiles-daemon.enable = lib.mkForce false;

  # AMD-side: don't run TLP or thermald (asusd owns power; thermald is
  # Intel-only anyway).
  services.tlp.enable = lib.mkForce false;
  services.thermald.enable = lib.mkForce false;

  environment.systemPackages = with pkgs; [ asusctl ];
}
