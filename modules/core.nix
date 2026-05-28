{ config, lib, pkgs, ... }:

{
  # Flakes + new CLI on by default. You're already living in flake-land.
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    trusted-users = [ "root" "architect" ];
  };

  # Garbage-collect old generations weekly. Keep the last 14 days.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Locale, time, keyboard.
  time.timeZone = "America/New_York";   # adjust if you're elsewhere
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  # Networking.
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # The user.
  users.users.architect = {
    isNormalUser = true;
    description = "Jake";
    extraGroups = [
      "wheel"           # sudo
      "networkmanager"
      "video"
      "audio"
      "input"
    ];
    shell = pkgs.bash;
    # SSH pubkeys from the old Pop install — drop them in here post-backup
    # so you can ssh in from another machine if Hyprland ever fails to start.
    openssh.authorizedKeys.keys = [
      # "ssh-ed25519 AAAA... architect@g14"
    ];
  };

  # Sudo without password for wheel — pick one.
  # security.sudo.wheelNeedsPassword = false;

  # OpenSSH server — off by default, flip to true if you want remote access.
  services.openssh.enable = false;

  # Allow proprietary firmware/drivers (NVIDIA, etc.).
  nixpkgs.config.allowUnfree = true;
}
