{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./kitty.nix
    ./shell.nix
  ];

  home.username = "architect";
  home.homeDirectory = "/home/architect";
  home.stateVersion = "25.11";

  # User packages — apps that belong to you, not the system.
  home.packages = with pkgs; [
    # Browsers
    firefox

    # Launcher / notifications / lock
    wofi
    mako
    hyprlock
    hypridle

    # File manager
    nautilus

    # Media
    mpv
    imv

    # Dev
    gh                  # GitHub CLI
    lazygit
    neovim

    # Comms / misc — uncomment as needed
    # discord
    # slack
    # signal-desktop
    # obsidian
  ];

  # Let home-manager manage itself.
  programs.home-manager.enable = true;

  # XDG user dirs.
  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
