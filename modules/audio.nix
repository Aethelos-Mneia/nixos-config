{ config, lib, pkgs, ... }:

{
  # PipeWire — modern replacement for PulseAudio + JACK. Standard on NixOS.
  # Shared across all hosts; nothing here is machine-specific.
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;       # flip true if you ever run pro-audio
  };
}
