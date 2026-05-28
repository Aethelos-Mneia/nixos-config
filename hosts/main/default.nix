# ─────────────────────────────────────────────────────────────────────────────
# main — desktop. Hardware TBD.
#
# When you know the spec, do the following:
#   1. Decide AMD-only / Intel-only / NVIDIA / hybrid — import the right
#      module from ../../modules/hardware/.
#   2. workstation profile is wired in flake.nix via extraModules.
#   3. If you have specific monitors you want pinned, override the
#      `wayland.windowManager.hyprland.settings.monitor` list at the home
#      level for this host, OR set monitor lines in this file via
#      home-manager.users.architect = { ... };
# ─────────────────────────────────────────────────────────────────────────────

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # TODO: GPU, CPU microcode, monitor layout.

  system.stateVersion = "25.11";
}
