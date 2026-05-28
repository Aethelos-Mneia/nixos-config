{ config, lib, pkgs, ... }:

{
  # Bar at the top, themed by Stylix. Minimal modules — workspaces left,
  # clock center, status right. Easy to extend.
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 32;
      spacing = 4;

      modules-left   = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [ "clock" ];
      modules-right  = [ "tray" "network" "pulseaudio" "battery" "cpu" "memory" ];

      "hyprland/workspaces" = {
        format = "{name}";
        on-click = "activate";
      };

      "hyprland/window" = {
        max-length = 50;
        separate-outputs = true;
      };

      clock = {
        format = "{:%a %b %d  %H:%M}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
      };

      battery = {
        format = "{capacity}% {icon}";
        format-icons = [ "" "" "" "" "" ];
        states = { warning = 30; critical = 15; };
      };

      network = {
        format-wifi = " {essid}";
        format-ethernet = " {ipaddr}";
        format-disconnected = "⚠ offline";
        tooltip-format = "{ifname}: {ipaddr}";
        on-click = "nm-connection-editor";
      };

      pulseaudio = {
        format = "{volume}% {icon}";
        format-muted = "muted";
        format-icons = { default = [ "" "" "" ]; };
        on-click = "pavucontrol";
      };

      cpu = { format = " {usage}%"; interval = 5; };
      memory = { format = " {percentage}%"; interval = 5; };

      tray = { spacing = 8; };
    };

    # Layout sizing only — Stylix paints the colors.
    style = ''
      * {
        font-family: "Inter", "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }
      window#waybar {
        background: transparent;
      }
      .modules-left, .modules-center, .modules-right {
        padding: 0 8px;
      }
      #workspaces button {
        padding: 0 8px;
        margin: 4px 2px;
        border-radius: 6px;
      }
    '';
  };
}
