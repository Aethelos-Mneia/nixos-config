{ config, lib, pkgs, ... }:

# Laptop-specific feature set: power management, touchpad, brightness,
# battery-friendly defaults. Imported by hosts that are laptops.

{
  # Power profiles via the freedesktop daemon. Asus hosts override with
  # asusd; this is the default for non-Asus laptops (thinkpad).
  services.power-profiles-daemon.enable = lib.mkDefault true;

  # Touchpad behavior.
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true;
      disableWhileTyping = true;
      clickMethod = "clickfinger";
    };
  };

  # Brightness control without sudo.
  programs.light.enable = true;

  # Laptop-friendly kernel tuning.
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;            # don't aggressively swap on battery
    "vm.dirty_writeback_centisecs" = 1500;
  };

  # Firmware updates over USB / network for laptop firmware (Lenovo, etc.).
  services.fwupd.enable = true;
}
