{ config, lib, pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;     # battery reporting for some devices
        FastConnectable = true;
      };
    };
  };

  services.blueman.enable = true;
}
