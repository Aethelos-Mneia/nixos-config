{ config, lib, pkgs, ... }:

{
  # Terminal — Stylix themes colors and font. We only set behavior.
  programs.kitty = {
    enable = true;
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      window_padding_width = 8;
      confirm_os_window_close = 0;
      cursor_blink_interval = 0;
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
    };
    shellIntegration.enableBashIntegration = true;
  };
}
