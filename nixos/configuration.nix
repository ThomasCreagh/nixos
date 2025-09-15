{ config, pkgs, ... }:

{
  time.timeZone = "Europe/Dublin";

  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  users.users = {
    tom = {
      shell = pkgs.fish;
      isNormalUser = true;
      description = "tom";
      extraGroups = [ "networkmanager" "wheel" "audio" ];
      packages = with pkgs; [
        python3
        keepassxc
        libgcc
        clang
        zig
        pavucontrol
        obsidian
        home-manager
        unzip
        discord
        tor-browser
        linuxKernel.packages.linux_zen.perf
        unixtools.netstat
        wireshark
      ];
    };
    syncthing = {
      isSystemUser = true;
      group = "syncthing";
    };
  };

  environment = {
    systemPackages = with pkgs; [
      networkmanager
      neofetch
      neovim
      bash
      egl-wayland
      tree
    ];
  };

  services = {
    syncthing = {
      enable = true;
      user = "tom";
      guiAddress = "0.0.0.0:8384";
      dataDir = "/home/tom";
      settings = {
        options.urAccepted = -1;
        devices = {
          phone = {
            addresses = [ "157.90.171.125:22067" ];
            id = "LI52QQ5-437KNEK-AI2XKKP-FTAHE6Q-CMS6S2H-PKL2ZWI-3BSIPIC-DAIPCQH";
          };
        };
        folders = {
          "/home/tom/Sync" = {
            id = "t6ycq-p4mmn";
            devices = [ "phone" ];
          };
        };
      };
    };
  };


  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    fish.enable = true;
    git.enable = true;
    tmux.enable = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  services.ofono.enable = true;

  hardware.bluetooth.enable = true;

  networking = {
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 8384 ];
    hostName = "nixos";
  };

  system.stateVersion = "25.05";

}
