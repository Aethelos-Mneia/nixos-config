# ─────────────────────────────────────────────────────────────────────────────
# thinkpad — laptop. Hardware TBD.
#
# When you know the model, do the following:
#   1. Add the right nixos-hardware module to `extraModules` in flake.nix:
#        e.g. inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
#        Browse https://github.com/NixOS/nixos-hardware/tree/master/lenovo
#   2. Pick a GPU module:
#        - Intel iGPU only → no module needed; mesa handles it
#        - AMD iGPU only   → import ../../modules/hardware/amd-gpu.nix
#        - Hybrid w/ NVIDIA → import nvidia-hybrid + set bus IDs
#   3. profiles/laptop is wired in flake.nix via extraModules; no action.
#   4. If it has a fingerprint reader, enable services.fprintd.enable = true;
# ─────────────────────────────────────────────────────────────────────────────

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # TODO: confirm thinkpad model and fill in GPU + fingerprint config.

  system.stateVersion = "25.11";
}
