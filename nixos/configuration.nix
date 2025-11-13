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

  users.groups.libvirtd.members = ["tom"];
  users.users = {
    tom = {
      shell = pkgs.fish;
      isNormalUser = true;
      description = "tom";
      extraGroups = [
        "networkmanager"
        "wheel"
        "audio"
        "kvm"
        "libvirtd"
        "docker"
      ];
      packages = with pkgs; [
        python3
        keepassxc
        libgcc
        clang
        pavucontrol
        obsidian
        home-manager
        unzip
        discord
        tor-browser
        linuxKernel.packages.linux_zen.perf
        unixtools.netstat
        spotify
        swi-prolog
        libnotify
        grimblast
        wl-clipboard
        discord
        usbutils
        file
        niv
        signal-desktop
        vlc
        qbittorrent
        p7zip
        openvpn
        ardour
        pandoc
        wireguard-tools
				#mullvad-vpn
        traceroute
        steam
        thunderbird
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
      git
      dnsmasq
      spice spice-gtk
      spice-protocol
      win-virtio
      win-spice
      virt-viewer
      openssl
    ];
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    extraPackages = [ pkgs.docker-buildx ];
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [ "virbr0" "br0" ];
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
      ovmf.enable = true;
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;
  services.spice-vdagentd.enable = true;

  services = {
    libinput = {
      enable = true;
      touchpad.sendEventsMode = "disabled";
    };
		#mullvad-vpn.enable = true;
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
    displayManager.ly.enable = true;
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


  programs.virt-manager.enable = true;
  programs.nix-ld.enable = true;
  programs = {
    wireshark = {
      enable = true;
      dumpcap.enable = true;
    };
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
  # steam 32 bit libs
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

	#networking.firewall.checkReversePath = false;
  networking.nat = {
    enable = true;
    internalInterfaces = ["virbr0"];
    externalInterface = "wlp5s0";
  };


  networking = {
    networkmanager.enable = true;
    firewall = {
      trustedInterfaces = [ "wlp5s0" "virbr0" ];
      allowedTCPPorts = [ 8384 ];
      allowedUDPPorts = [ 41641 ];
    };
    hostName = "nixos";
  };

  system.stateVersion = "25.05";

}
