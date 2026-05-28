{ config, lib, pkgs, ... }:

# NVIDIA hybrid graphics (PRIME render offload).
#
# iGPU drives the display for battery life; dGPU only powers up for apps
# you explicitly launch with the `nvidia-offload` wrapper.
#
# Per-host overrides REQUIRED in the host's default.nix:
#   hardware.nvidia.prime.amdgpuBusId  = "PCI:X:0:0";
#   hardware.nvidia.prime.nvidiaBusId  = "PCI:Y:0:0";
# Find these with: lspci | grep -E 'VGA|3D' — then convert hex bus to decimal.

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;                                              # proprietary
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;                               # `nvidia-offload <cmd>`
      };
      # Bus IDs set per-host (see comment above).
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
