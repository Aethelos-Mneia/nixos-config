{ config, lib, pkgs, ... }:

{
  # System-level Hyprland: registers the desktop entry so a display manager
  # can pick it, sets up the right portal bits, enables wayland session vars.
  programs.hyprland = {
    enable = true;
    withUWSM = true;       # systemd user-session manager — cleaner shutdown
    xwayland.enable = true;
  };

  # Display manager: SDDM with Wayland support. Greetd is the leaner option
  # if you want to drop the DM later; SDDM gives a polished first impression.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # XDG portals — file pickers, screen share, etc. Hyprland portal +
  # gtk portal cover most apps.
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # Wayland-friendly env vars.
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";          # Electron apps on Wayland
    MOZ_ENABLE_WAYLAND = "1";      # Firefox on Wayland
    QT_QPA_PLATFORM = "wayland";
  };

  # Polkit agent — needed for GUI auth prompts under Hyprland.
  security.polkit.enable = true;
}
