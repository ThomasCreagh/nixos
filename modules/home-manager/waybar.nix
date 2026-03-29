{ config, pkgs, inputs, ... }:

{
  # top of the screen bar
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "battery" "network" ];

        "clock" = {
          interval = 60;
          format = "{:%Y-%m-%d %H:%M}";
        };

        "pulseaudio" = {
          format = " {volume}%";
          format-muted = " Muted";
          on-click = "pavucontrol";
        };

       "battery" = {
          format = "{capacity}% {icon}";
          format-icons = [ "" "" "" "" "" ];
          interval = 60;
        };

        "network" = {
          format-wifi = " {essid} ({signalStrength}%)";
          format-ethernet = " {ifname}";
          format-disconnected = "⚠ Disconnected";
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            default = "";
          };
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 20px;
        color: #ffffff;
      }

      window#waybar {
        background: rgba(30, 30, 46, 0.75); /* 50% opacity */
        border-radius: 6px;
      }

      #clock, #battery, #pulseaudio, #network {
        padding: 0 10px;
      }

      #workspaces button {
        padding: 0 8px;
        border: none;
        background: transparent;
        color: #888;
      }

      #workspaces button.active {
        color: #fff;
      }
    '';
  };
}
