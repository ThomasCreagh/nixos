{ config, pkgs, ... }:

{
  imports = [
    ../modules/nixos/audio.nix
    ../modules/nixos/desktop.nix
    ../modules/nixos/networking.nix
    ../modules/nixos/packages.nix
    ../modules/nixos/postgresql.nix
    ../modules/nixos/syncthing.nix
    ../modules/nixos/virtulisation.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

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
        "realtime"
        "jackaudio"
      ];
    };
  };
  users.groups.libvirtd.members = ["tom"];

  services = {
    dbus.enable = true;
    displayManager.ly.enable = true;
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    fish.enable = true;
    git.enable = true;
    tmux.enable = true;
    nix-ld.enable = true;
  };

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

  system.stateVersion = "25.05";
}
