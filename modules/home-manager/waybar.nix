{
  config,
  lib,
  pkgs,
  ...
}: let
  commonDeps = with pkgs; [coreutils gnugrep systemd];
  # Function to simplify making waybar outputs
  mkScript = {
    name ? "script",
    deps ? [],
    script ? "",
  }:
    lib.getExe (pkgs.writeShellApplication {
      inherit name;
      text = script;
      runtimeInputs = commonDeps ++ deps;
    });
  # Specialized for JSON outputs
  mkScriptJson = {
    name ? "script",
    deps ? [],
    script ? "",
    text ? "",
    tooltip ? "",
    alt ? "",
    class ? "",
    percentage ? "",
  }:
    mkScript {
      inherit name;
      deps = [pkgs.jq] ++ deps;
      script = ''
        ${script}
        jq -cn \
          --arg text "${text}" \
          --arg tooltip "${tooltip}" \
          --arg alt "${alt}" \
          --arg class "${class}" \
          --arg percentage "${percentage}" \
          '{text:$text,tooltip:$tooltip,alt:$alt,class:$class,percentage:$percentage}'
      '';
    };

  swayCfg = config.wayland.windowManager.sway;
  hyprlandCfg = config.wayland.windowManager.hyprland;

  c = import ./colors.nix;
  # Colour just the icon, leaving the value in the normal text colour
  icon = color: glyph: "<span color='${color}'>${glyph}</span>";
  # Open a TUI in its own Ghostty window; hyprland floats the tui.* class
  tui = name: cmd: "${lib.getExe config.programs.ghostty.package} --class=tui.${name} -e ${cmd}";

  bar = {
    exclusive = true;
    passthrough = false;
    height = 35;
    margin = "0";
    position = "top";
    modules-left =
      ["custom/menu"]
      ++ (lib.optionals swayCfg.enable [
        "sway/workspaces"
        "sway/mode"
      ])
      ++ (lib.optionals hyprlandCfg.enable [
        "hyprland/workspaces"
        "hyprland/submap"
      ]) ++ [
        "custom/currentplayer"
        "custom/player"
    ];
  };

  modules = {
    "hyprland/workspaces" = {
      all-outputs = true;
    };
    clock = {
      format = "{:%H:%M  <span color='${c.grey}'>%d/%m/%y</span>}";
      # Relaunching a running Thunderbird does nothing visible, so jump to
      # its window if it's open and only start it otherwise.
      on-click = mkScript {
        deps = [hyprlandCfg.finalPackage pkgs.thunderbird];
        script = ''
          if hyprctl clients | grep -q "class: thunderbird"; then
            hyprctl dispatch 'hl.dsp.focus({ window = "class:thunderbird" })'
          else
            thunderbird &
          fi
        '';
      };
      tooltip-format = "<tt><small>{calendar}</small></tt>";
    };

    "group/stats" = {
      orientation = "inherit";
      modules = ["cpu" "memory"];
    };
    cpu = {
      interval = 5;
      format = "${icon c.lightblue "󰻠"} {usage:2}%";
    };
    memory = {
      interval = 5;
      format = "${icon c.yellow "󰍛"} {percentage:2}%";
      tooltip-format = "{used:0.1f}G / {total:0.1f}G used";
    };

    "pulseaudio" = {
      format = "${icon c.purple "{icon}"} {volume}%";
      format-muted = icon c.dim "󰸈";
      format-bluetooth = "${icon c.purple "{icon} 󰂯"} {volume}%{format_source}";
      format-bluetooth-muted = icon c.dim "{icon} 󰂯";
      format-source = "";
      format-source-muted = " 󰍭";
      format-icons = {
        default = [
          "󰕿"
          "󰖀"
          "󰖀"
          "󰕾"
        ];
        headphone = "󰋋";
        headset = "󰋎";
      };
      on-click = lib.getExe pkgs.pavucontrol;
    };
    battery = {
      interval = 10;
      states = {
        warning = 30;
        critical = 15;
      };
      format-icons = [
        "󰁺"
        "󰁻"
        "󰁼"
        "󰁽"
        "󰁾"
        "󰁿"
        "󰂀"
        "󰂁"
        "󰂂"
        "󰁹"
      ];
      format = "${icon c.green "{icon}"} {capacity}%";
      format-warning = "${icon c.yellow "{icon}"} {capacity}%";
      format-critical = "${icon c.red "{icon}"} {capacity}%";
      format-charging = "${icon c.green "󰂄"} {capacity}%";
      tooltip-format = "{time}";
    };
    "sway/window" = {
      max-length = 20;
    };
    network = {
      interval = 3;
      format-wifi = icon c.blue "󰖩";
      format-ethernet = icon c.blue "󰈀";
      format-disconnected = icon c.dim "󰖪";
      tooltip-format = ''
        {essid}
        {ifname}
        {ipaddr}/{cidr}
        Up: {bandwidthUpBits}
        Down: {bandwidthDownBits}'';
      on-click = tui "nmtui" "${pkgs.networkmanager}/bin/nmtui";
    };
    bluetooth = {
      format = icon c.dim "󰂲";
      format-off = icon c.dim "󰂲";
      format-disabled = icon c.dim "󰂲";
      format-connected = icon c.blue "󰂱";
      tooltip-format = "Bluetooth {status}";
      tooltip-format-connected = "{device_enumerate}";
      tooltip-format-enumerate-connected = "{device_alias}";
      on-click = tui "bluetui" (lib.getExe pkgs.bluetui);
    };
    # Wired headphones, from the sound card's Headphones port
    "custom/headphones" = {
      interval = 2;
      return-type = "json";
      exec = mkScript {
        deps = [pkgs.pulseaudio pkgs.jq];
        script = ''
          if pactl -f json list cards \
            | jq -e '[.[].ports[] | select(.type == "Headphones" and .availability == "available")] | length > 0' >/dev/null
          then
            echo '{"text": "<span color='"'${c.purple}'"'>󰋋</span>", "tooltip": "Headphones plugged in", "class": "plugged"}'
          else
            echo '{"text": "<span color='"'${c.dim}'"'>󰟎</span>", "tooltip": "No headphones plugged in", "class": "unplugged"}'
          fi
        '';
      };
      on-click = lib.getExe pkgs.pavucontrol;
    };
    "custom/menu" = {
      return-type = "json";
      exec = mkScriptJson {
        tooltip = "$USER@$HOSTNAME";
        alt = "$(grep LOGO /etc/os-release | cut -d = -f2 | cut -d '\"' -f2)";
      };
      format = "{icon}";
      format-icons = {
        "nix-snowflake" = "";
        "ubuntu-logo" = "󰕈";
      };
    };
    "custom/currentplayer" = {
      interval = 2;
      return-type = "json";
      # Hide the module entirely when nothing is playing
      exec-if = mkScript {
        deps = [pkgs.playerctl];
        script = ''[ -n "$(playerctl -l 2>/dev/null)" ]'';
      };
      exec = mkScriptJson {
        deps = [pkgs.playerctl];
        script = ''
          all_players=$(playerctl -l 2>/dev/null)
          selected_player="$(playerctl status -f "{{playerName}}" 2>/dev/null || true)"
          clean_player="$(echo "$selected_player" | cut -d '.' -f1)"
        '';
        alt = "$clean_player";
        tooltip = "$all_players";
      };
      format = "{icon}{text}";
      format-icons = {
        "Celluloid" = "󰎁 ";
        "spotify" = "󰓇 ";
        "ncspot" = "󰓇 ";
        "qutebrowser" = "󰖟 ";
        "firefox" = " ";
        "discord" = "󰙯 ";
        "sublimemusic" = " ";
        "kdeconnect" = "󰄡 ";
        "chromium" = " ";
      };
    };
    "custom/player" = {
      exec-if = mkScript {
        deps = [pkgs.playerctl];
        script = ''
          selected_player="$(playerctl status -f "{{playerName}}" 2>/dev/null || true)"
          playerctl status -p "$selected_player" 2>/dev/null
        '';
      };
      exec = mkScript {
        deps = [pkgs.playerctl];
        script = ''
          selected_player="$(playerctl status -f "{{playerName}}" 2>/dev/null || true)"
          playerctl metadata -p "$selected_player" \
            --format '{"text": "{{artist}} - {{title}}", "alt": "{{status}}", "tooltip": "{{artist}} - {{title}} ({{album}})"}' 2>/dev/null
        '';
      };
      return-type = "json";
      interval = 2;
      max-length = 30;
      format = "{icon} {text}";
      format-icons = {
        "Playing" = "󰐊";
        "Paused" = "󰏤";
        "Stopped" = "󰓛";
      };
      on-click = mkScript {
        deps = [pkgs.playerctl];
        script = "playerctl play-pause";
      };
    };
    "custom/rfkill" = {
      interval = 3;
      exec-if = mkScript {
        deps = [pkgs.util-linux];
        script = "rfkill list wifi | grep yes -q";
      };
      exec = "echo 󰀝";
    };
  };
in {
  systemd.user.services.waybar = {
    Unit = {
      # Let it try to start a few more times
      StartLimitBurst = 30;
      # Reload instead of restarting
      X-Restart-Triggers = lib.mkForce [];
      X-SwitchMethod = "reload";
    };
  };
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or []) ++ ["-Dexperimental=true"];
    });
    systemd.enable = true;
    # No `output`, so the same bar appears on every monitor.
    settings = {
      primary = modules // bar // {
        modules-right = [
          "group/stats"
          "tray"
          "network"
          "bluetooth"
          "custom/rfkill"
          "battery"
          "custom/headphones"
          "pulseaudio"
          "clock"
        ];
      };
    };
    # Cheatsheet:
    # x -> all sides
    # x y -> vertical, horizontal
    # x y z -> top, horizontal, bottom
    # w x y z -> top, right, bottom, left
    style =
      /*
      css
      */
      ''
        * {
          font-family: "JetBrainsMono Nerd Font", monospace;
          font-size: 12pt;
          border: none;
          border-radius: 0;
          min-height: 0;
        }

        window#waybar {
          background-color: transparent;
          color: ${c.text};
        }

        tooltip {
          background-color: ${c.background};
          border: 1px solid ${c.border};
          border-radius: 0.5em;
        }
        tooltip label {
          color: ${c.text};
          padding: 0.2em 0.4em;
        }

        .modules-left,
        .modules-right {
          background-color: ${c.background};
          border: 1px solid ${c.border};
          border-radius: 0.5em;
          margin-top: 3px;
        }
        .modules-left {
          margin-left: 4px;
        }
        .modules-right {
          margin-right: 4px;
        }

        #cpu,
        #memory,
        #network,
        #bluetooth,
        #custom-headphones,
        #custom-rfkill,
        #battery,
        #pulseaudio,
        #custom-currentplayer,
        #custom-player {
          padding: 0 0.6em;
        }

        #workspaces {
          margin: 0 0.4em;
        }
        #workspaces button {
          color: ${c.grey};
          background: transparent;
          box-shadow: none;
          text-shadow: none;
          padding: 0 0.5em;
          margin: 0.25em 0.1em;
          border-radius: 0.4em;
        }
        #workspaces button:hover {
          background: ${c.upper_background};
          color: ${c.text};
        }
        #workspaces button.hidden {
          background-color: ${c.yellow};
          color: ${c.background};
        }
        /* Shown on the other monitor but not focused */
        #workspaces button.visible {
          background-color: ${c.upper_background};
          color: ${c.blue};
        }
        #workspaces button.focused,
        #workspaces button.active {
          background-color: ${c.blue};
          color: ${c.background};
        }
        #workspaces button.urgent {
          background-color: ${c.red};
          color: ${c.background};
        }

        #custom-menu {
          background-color: ${c.upper_background};
          color: ${c.blue};
          padding: 0 1em 0 0.7em;
          border-radius: 0.5em;
        }
        #clock {
          background-color: ${c.upper_background};
          color: ${c.text};
          padding: 0 0.8em;
          border-radius: 0.5em;
        }

        #custom-currentplayer {
          padding-right: 0;
        }
        #custom-player {
          padding-left: 0;
        }
        #custom-rfkill {
          color: ${c.red};
        }
        #battery.critical:not(.charging) {
          color: ${c.red};
        }
        /* Apps switch between black (light mode) and white (dark mode) tray
           icons; blue keeps both readable on the dark bar. */
        #tray {
          background-color: ${c.blue};
          border-radius: 0.4em;
          margin: 0.25em 0.3em;
          padding: 0 0.4em;
        }
        #tray > .needs-attention {
          background-color: ${c.red};
          border-radius: 0.4em;
        }
      '';
  };
}
