{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tom";
  home.homeDirectory = "/home/tom";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    nerd-fonts.jetbrains-mono
    wbg
    brightnessctl
    swaylock
    swayidle
    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # rebuild command
    (writeShellScriptBin "rebuild" ''
      if [ $# -lt 1 ]; then
        echo "Usage: rebuild <hostname>"
        exit 1
      fi

      HOST="$1"
      bash ~/.dotfiles/rebuild $HOST
    '')

    # save system to github
    (writeShellScriptBin "save" ''
      bash ~/.dotfiles/save
    '')

    # trash
    (writeShellScriptBin "trash" ''
      if [ $# -lt 1 ]; then
        echo "Usage: trash <file or dir>"
        exit 1
      fi

      DIR_NAME="$1"
      mv $DIR_NAME ~/.trash/
    '')


    # save an shutdown/reboot commands
    (writeShellScriptBin "shutsave" ''
      bash ~/.dotfiles/save
      echo "shutting down now."
      shutdown now
    '')

    (writeShellScriptBin "rebsave" ''
      bash ~/.dotfiles/save
      echo "rebooting now."
      sudo reboot 0
    '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/tom/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # programs

  # nvim
  programs.fish = {
    enable = true;
    shellInit = ''
      set -g fish_key_bindings fish_vi_key_bindings
      neofetch
    '';
  };
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
  };
  home.file.".config/nvim".source = ../nvim;

  programs.feh.enable = true; # image viewer

  gtk = {
    enable = true;
    theme.name = "Adwaita";
    iconTheme.name = "Adwaita";
    font.name = "Cantarell 14";
  };
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "Breeze";
  };
  xresources.properties = {
    "Xft.dpi" = 144;
  };

  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        # These won't add gaps themselves, but are required context
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

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    installVimSyntax = true;
    settings = {
      font-size = 20;
      theme = "tokyonight_night";
    };
  };

  programs.git = {
    enable = true;
    userEmail = "github@thomascreagh.mailer.me";
    userName = "Thomas Creagh";
  };

  # browser
  programs.firefox = {
    enable = true;
    policies = {
      Homepage = {
        URL = "https://nixos.org";
        Locked = true;
      };
      NewTabPage = false;
      DisableTelemetry = true;
    };

    profiles.default = {
      settings = {
        "browser.startup.homepage" = "https://nixos.org";
        "browser.search.defaultenginename" = "DuckDuckGo";
        "sidebar.verticalTabs" = "true";
        "browser.newtabpage.enabled" = "false";
        "browser.newtabpage.activity-stream.enabled" = "false";
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      userChrome = ''
        #personal-bookmarks #import-button {
          display: none !important;
        }
      '';
      extensions = {
        force = true;
        packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          sponsorblock
          youtube-shorts-block
          #vimium
        ];
      };
      bookmarks = {
        force = true;
        settings = [
          {
            name = "Toobar bookmarks";
            toolbar = true;
            bookmarks = [
              {
                name = "homepage";
                url = "https://nixos.org/";
              }
              {
                 name = "com";
                 bookmarks = [
                   {
                     name = "whatsapp";
                     url = "https://web.whatsapp.com";
                   }
                   {
                     name = "proton";
                     url = "https://proton.me";
                   }
                   {
                     name = "addy";
                     url = "https://addy.io";
                   }
                   {
                     name = "gmail";
                     url = "https://gmail.com";
                   }
                   {
                     name = "linkedin";
                     url = "https://linkedin.com";
                   }
                   {
                     name = "blackboard";
                     url = "https://tcd.blackboard.com/";
                   }
                 ];
              }
              {
                 name = "nixos";
                 bookmarks = [
                   {
                     name = "nix packages";
                     url = "https://search.nixos.org/packages";
                   }
                   {
                     name = "nix options";
                     url = "https://search.nixos.org/options?";
                   }
                   {
                     name = "nix flakes";
                     url = "https://search.nixos.org/flakes?";
                   }
                   {
                     name = "nix wiki";
                     url = "https://wiki.nixos.org/wiki/NixOS_Wiki";
                   }
                   {
                     name = "home-manager manual";
                     url = "https://nix-community.github.io/home-manager/";
                   }
                 ];
              }
              {
                 name = "job";
                 bookmarks = [
                   {
                     name = "linkedin";
                     url = "https://www.linkedin.com/in/thomas-creagh/";
                   }
                   {
                     name = "github";
                     url = "https://github.com/ThomasCreagh";
                   }
                   {
                     name = "personal website";
                     url = "https://thomascreagh.github.io";
                   }
                 ];
              }
              {
                 name = "prog misc";
                 bookmarks = [
                   {
                     name = "css docs";
                     url = "https://developer.mozilla.org/en-US/docs";
                   }
                 ];
              }
              {
                 name = "zig";
                 bookmarks = [
                   {
                     name = "zig";
                     url = "https://ziglang.org";
                   }
                 ];
              }
              {
                 name = "cheatsheets";
                 bookmarks = [
                   {
                     name = "firefox";
                     url = "https://support.mozilla.org/en-US/kb/keyboard-shortcuts-perform-firefox-tasks-quickly?redirectslug=Keyboard+shortcuts&redirectlocale=en-US";
                   }
                   {
                     name = "tmux";
                     url = "https://tmuxcheatsheet.com/";
                   }
                 ];
              }

            ];
          }
        ];
      };
      search = {
        force = true;
        default = "DuckDuckGo";
        order = [ "DuckDuckGo" ];
        engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "NixOS Wiki" = {
            urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@nw" ];
          };
          "DuckDuckGo" = {
            urls = [{ template = "https://duckduckgo.com/?t=h_&q={searchTerms}&ia=web"; }];
            iconUpdateURL = "https://duckduckgo.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@dk" ];
          };
        };
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # services
  services = {
    mako = {
      enable = true;
      settings = {
        "actionable=true" = {
          anchor = "top-left";
        };
        actions = true;
        anchor = "top-right";
        background-color = "#3a5760";
        border-color = "#a1d1cc";
        border-radius = 10;
        default-timeout = 0;
        height = 100;
        icons = true;
        ignore-timeout = false;
        layer = "top";
        margin = 10;
        markup = true;
        width = 300;
      };
    };
    swayidle = {
      enable = true;
      timeouts = [
        { timeout = 300; command = "swaylock -f -c 000000"; } # lock after 5 min
      ];
      events = [
        { event = "before-sleep"; command = "swaylock -f -c 000000"; }
        { event = "lock"; command = "swaylock -f -c 000000"; }
      ];
    };
  };


  # hyprland
  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = ''
      animations {
        enabled = no
      }
      device:synps/2-synaptics-touchpad {
        enabled = false
      }
    '';

    settings = {
      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      "$fileManager" = "dolphin";
      "$webBrowser" = "firefox";
      "$menu" = "wofi --show drun";

			# swayidle -w timeout 300 '
      exec-once = [
        "waybar &"
        "wbg ~/.dotfiles/wallpapers/0.jpg"
        "mako"
        "swaylock -f -c 000000' before-sleep 'swaylock -f -c 000000'"
      ];

      bind = [
        "$mod, Q, exec, $terminal"
        "$mod, W, exec, $webBrowser"
        "$mod, K, exec, keepassxc"
        "$mod, Y, exec, signal-desktop"
        "$mod, O, exec, obsidian"
        "$mod, D, exec, discord"
        "$mod, E, exec, $fileManager"
        "$mod, R, exec, $menu"

        "$mod, C, killactive"
        "$mod, M, exit"
        "$mod, V, togglefloating"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
        "$mod, F, fullscreen, 1"
        "$mod SHIFT, F, fullscreen"

        # SUPER+` takes a region screenshot, saves to Pictures, copies to clipboard
        "$mod, grave, exec, grimblast save area - | tee ~/Pictures/screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png | wl-copy"

        # Move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Switch workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 8"
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
        "$mod SHIFT, 9, movetoworkspace, 8"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Special workspace
        "$mod, S, togglespecialworkspace, magic"
        "$mod, SHIFT S, movetoworkspace, special:magic"

        # resize windows click and drag
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
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

      monitor = [
        "eDP-1, preferred, auto, 1"
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

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 8;
          passes = 2;
        };
      };
    };
  };
}
