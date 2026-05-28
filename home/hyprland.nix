{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;

    # Stylix injects colors/fonts/border radius via its own hyprland module,
    # so we focus here on layout, keybinds, and behavior.
    settings = {
      # ─── Monitors ─────────────────────────────────────────────────────
      # `preferred` lets Hyprland pick native res/refresh. Once you know
      # what your G14 panel reports, swap to an explicit line like:
      #   "eDP-1,2880x1800@120,0x0,1.5"
      monitor = [ ",preferred,auto,1" ];

      # ─── Startup ──────────────────────────────────────────────────────
      exec-once = [
        "waybar"
        "mako"
        "hypridle"
        "nm-applet --indicator"
        "blueman-applet"
      ];

      # ─── Input ────────────────────────────────────────────────────────
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          tap-to-click = true;
        };
      };

      # ─── General ──────────────────────────────────────────────────────
      general = {
        gaps_in = 6;
        gaps_out = 12;
        border_size = 2;
        layout = "dwindle";
        resize_on_border = true;
      };

      # ─── Decoration — the glassy look ────────────────────────────────
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 6;
          passes = 3;
          new_optimizations = true;
        };
        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
        };
      };

      # ─── Animations ──────────────────────────────────────────────────
      animations = {
        enabled = true;
        bezier = "smooth, 0.25, 0.1, 0.25, 1.0";
        animation = [
          "windows, 1, 5, smooth"
          "border, 1, 8, default"
          "fade, 1, 5, smooth"
          "workspaces, 1, 4, smooth, slide"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
      };

      # ─── Keybinds ────────────────────────────────────────────────────
      "$mod" = "SUPER";

      bind = [
        # Apps
        "$mod, Return, exec, kitty"
        "$mod, B, exec, firefox"
        "$mod, E, exec, nautilus"
        "$mod, SPACE, exec, wofi --show drun"

        # Window management
        "$mod, Q, killactive,"
        "$mod SHIFT, E, exit,"
        "$mod, V, togglefloating,"
        "$mod, F, fullscreen,"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"

        # Focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Workspaces 1-9
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"

        # Move window to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"

        # Screenshots
        ", Print, exec, hyprshot -m output"
        "SHIFT, Print, exec, hyprshot -m region"
        "$mod, Print, exec, hyprshot -m window"

        # Lock
        "$mod, L, exec, hyprlock"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Volume + brightness — repeat on hold via `e`.
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      # Media keys.
      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
    };
  };

  # Lock screen — keep it simple, Stylix themes it.
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 2;
      };
      background = [{
        path = "screenshot";
        blur_passes = 3;
        blur_size = 8;
      }];
    };
  };

  # Idle daemon — dim, lock, suspend with sane timings.
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        { timeout = 300;  on-timeout = "brightnessctl -s set 10"; on-resume = "brightnessctl -r"; }
        { timeout = 600;  on-timeout = "loginctl lock-session"; }
        { timeout = 1200; on-timeout = "systemctl suspend"; }
      ];
    };
  };
}
