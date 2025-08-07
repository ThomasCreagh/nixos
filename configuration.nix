# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  # Set your time zone.
  time.timeZone = "Europe/Dublin";

  # Select internationalisation properties.
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    tom = {
      shell = pkgs.fish;
      isNormalUser = true;
      description = "tom";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
        ghostty	
        brave
	keepassxc
	libgcc
	clang
	zig
      ];
    };
    syncthing = {
      isSystemUser = true;
      group = "syncthing";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  environment = {
    systemPackages = with pkgs; [
      neofetch
      neovim
      bash
      egl-wayland
    ];
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };


  services = {
    xserver = {
      xkb = {
        layout = "ie";
        variant = "";
      };
    };
    libinput.touchpad.naturalScrolling = false;
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


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking = {
    # Enable networking
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 8384 ];
    hostName = "nixos"; # Define your hostname.
  };



  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
