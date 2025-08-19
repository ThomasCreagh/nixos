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
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.wbg
    pkgs.brightnessctl
    pkgs.swaylock
    pkgs.swayidle
    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
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
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
  };
  home.file.".config/nvim".source = ../nvim;

  programs.imv.enable = true; # image viewer

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
    profiles.default = {
      bookmarks = {
        force = true;
        settings = [
#          {
#            name = "wikipedia";
#            tags = [ "wiki" ];
#            keyword = "wiki";
#            url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
#          }
#          {
#            name = "kernel.org";
#            url = "https://www.kernel.org";
#          }
#          "separator"
          {
            name = "Nix sites";
            toolbar = true;
            bookmarks = [
              {
                name = "homepage";
                url = "https://nixos.org/";
              }
              {
                name = "wiki";
                tags = [ "wiki" "nix" ];
                url = "https://wiki.nixos.org/";
              }
              {
                name = "zig";
                tags = [ "zig" ];
                url = "https://ziglang.org/";
              }
            ];
          }
        ];
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # services
  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 300; command = "swaylock -f -c 000000"; } # lock after 5 min
    ];
    events = [
      { event = "before-sleep"; command = "swaylock -f -c 000000"; }
      { event = "lock"; command = "swaylock -f -c 000000"; }
    ];
  };


  # hyprland
  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = ''
      animations {
        enabled = no
      }
    '';

    settings = {
      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      "$fileManager" = "dolphin";
      "$webBrowser" = "firefox";
      "$menu" = "wofi --show drun";

      exec-once = [
        "waybar &"
        "wbg ~/.dotfiles/wallpapers/0.jpg"
#        "swww init &"
#        "nm-applet &"
      ];

      bind = [
        "$mod, Q, exec, $terminal"
        "$mod, W, exec, $webBrowser"
        "$mod, K, exec, keepassxc"
        "$mod, O, exec, obsidian"
        "$mod, D, exec, discord"
        "$mod, C, killactive"
        "$mod, M, exit"
        "$mod, E, exec, $fileManager"
        "$mod, V, togglefloating"
        "$mod, R, exec, $menu"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"

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
        kb_layout = "ie";
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
