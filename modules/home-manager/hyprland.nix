{ config, pkgs, inputs, ... }:

{
  # hyprland
  wayland.windowManager.hyprland = {
    enable = true;

		#extraConfig = ''
    		#  animations {
    		#    enabled = no
    		#  }
    		#'';

    settings = {
      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      "$fileManager" = "dolphin";
      "$webBrowser" = "firefox";
      "$menu" = "wofi --show drun";
      animations = {
        enabled = false;
      };


      exec-once = [
        #"waybar &"
        "wbg ~/.dotfiles/wallpapers/3.jpg"
        "mako"
      ];

      bind = [
        "$mod, Q, exec, $terminal"
        "$mod, W, exec, $webBrowser"
        "$mod, Y, exec, spotify"
        "$mod, O, exec, obsidian"
        "$mod, D, exec, discord"
        "$mod, T, exec, thunderbird"
        "$mod, E, exec, $fileManager"
        "$mod, R, exec, $menu"
        "$mod, S, exec, signal-desktop"

        "$mod, C, killactive"
        "$mod, M, exit"
        "$mod, V, togglefloating"
        "$mod, P, pseudo"
        "$mod, I, layoutmsg, togglesplit"
        "$mod, F, fullscreen, 1"
        "$mod SHIFT, F, fullscreen"

        # SUPER+` takes a region screenshot, saves to Pictures, copies to clipboard
        "$mod, grave, exec, grimblast save area - | tee ~/Pictures/screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png | wl-copy"

        # Move focus
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

        # Switch workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move active window to a workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
      ];

      bindm = [
        # resize windows left click and drag
        "$mod, mouse:272, movewindow"
        # resize windows right click and drag
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      # just mirror image
      monitor = [
        "eDP-1, preferred, 0x0, 1"
        ", preferred, 0x0, 1, mirror, eDP-1"
      ];

      input = {
        kb_layout = "us";
        touchpad = {
          natural_scroll = true;
        };
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      general = {
        gaps_in = 3;
        gaps_out = 4;
      };

      decoration = {
        rounding = 6;
        blur = {
          enabled = true;
          size = 8;
          passes = 2;
        };
      };
    };
  };
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];

    config = {
      common = {
        default = [ "hyprland" "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
  };

}
