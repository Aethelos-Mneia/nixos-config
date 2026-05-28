{ config, lib, pkgs, ... }:

# Pure AMD GPU stack — amdgpu driver, Vulkan, VAAPI.
# For machines where AMD is the only GPU (no NVIDIA in the mix).

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      amdvlk                # AMD's open Vulkan driver (alongside mesa's RADV)
      vaapiVdpau
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      amdvlk
    ];
  };

  # Use the kernel's amdgpu driver. Listed in videoDrivers for X11
  # compatibility; Wayland uses KMS directly so the list mostly matters
  # for fallback / app probing.
  services.xserver.videoDrivers = [ "amdgpu" ];

  # ROCm — compute stack for ML / Blender / etc. Uncomment if you want it.
  # Adds substantial closure size; only enable on workstations that need it.
  # systemd.tmpfiles.rules = [ "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}" ];
  # environment.systemPackages = with pkgs; [
  #   rocmPackages.clr.icd
  #   rocmPackages.rocm-smi
  # ];
}
