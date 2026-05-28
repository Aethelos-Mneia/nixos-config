{ config, lib, pkgs, ... }:

{
  # Stylix takes one palette + one wallpaper and themes EVERYTHING:
  # Hyprland borders, Waybar, GTK, Qt, terminal, neovim, mako, sddm, etc.
  # One source of truth for the whole aesthetic.
  stylix = {
    enable = true;
    polarity = "dark";

    # Tokyo Night Storm — cool dark blue-green. Matches the screenshot
    # aesthetic. Swap commented schemes below if it doesn't land:
    #   - kanagawa            (deep teal/indigo, Japanese-inspired)
    #   - nord                (clean cool blue)
    #   - catppuccin-frappe   (softer cool)
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";

    # Wallpaper. Defaults to a built-in dark nixos wallpaper so the first
    # build doesn't error on a missing file. Once you've dropped your own
    # image at ../wallpapers/current.jpg, swap the line below.
    image = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
    # image = ../wallpapers/current.jpg;

    # Fonts — JetBrains Mono is a solid default for the terminal/code feel.
    # Inter for UI is clean and unobtrusive.
    fonts = {
      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 11;
        terminal = 12;
        desktop = 10;
        popups = 10;
      };
    };

    # Cursor.
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    # Opacity — the "glassy" look from the screenshots.
    opacity = {
      applications = 1.0;
      terminal = 0.85;
      desktop = 1.0;
      popups = 0.9;
    };
  };

  # Make sure font packages Stylix references are actually installed system-wide
  # so SDDM and other early-boot UI can find them too.
  fonts.packages = with pkgs; [
    jetbrains-mono
    inter
    dejavu_fonts
    noto-fonts
    noto-fonts-emoji
    nerd-fonts.jetbrains-mono
  ];
}
