{ config, lib, pkgs, ... }:

{
  # ─── Audio ───────────────────────────────────────────────────────────────
  # PipeWire replaces PulseAudio. Standard on modern NixOS.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;
  };

  # ─── Asus tooling ────────────────────────────────────────────────────────
  # asusctl: keyboard backlight, fan profiles, charge limit, AniMe Matrix.
  # supergfxctl: GPU mode switching (hybrid / integrated / dedicated).
  services.asusd = {
    enable = true;
    enableUserService = true;
  };
  services.supergfxd.enable = true;

  # ─── Hybrid graphics (AMD Phoenix3 iGPU + NVIDIA RTX 4060 dGPU) ──────────
  # nixos-hardware's ga403 module covers most of this. These overrides
  # default to PRIME render offload — iGPU drives the display for battery
  # life, dGPU only spins up for apps you explicitly launch with
  # `nvidia-offload <cmd>` (alias below).
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;          # proprietary driver — `true` if you want NVK/open
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;   # installs `nvidia-offload` wrapper
      };
      # PCI bus IDs from your hardware probe (lspci output):
      #   01:00.0 NVIDIA  → "PCI:1:0:0"
      #   65:00.0 AMD     → "PCI:101:0:0"  (0x65 = 101 decimal)
      amdgpuBusId   = "PCI:101:0:0";
      nvidiaBusId   = "PCI:1:0:0";
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # ─── Power / thermal ─────────────────────────────────────────────────────
  services.power-profiles-daemon.enable = lib.mkDefault false;  # asusd takes over
  services.tlp.enable = false;                                  # conflicts w/ asusd
  services.thermald.enable = false;                             # Intel-only; AMD here

  # Bluetooth.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Touchpad / libinput.
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true;
      disableWhileTyping = true;
    };
  };
}
