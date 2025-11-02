{ config, pkgs, ... }:

{
  imports =
    [
      ./laptop-hardware.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "amdgpu.runpm=0"
    "amdgpu.deep_color=0"
  ];

  hardware.enableRedistributableFirmware = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchDocked = "ignore";
  services.power-profiles-daemon.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  swapDevices = [
    {
      device = "/swapfile";
      size   = 16384;
    }
  ];

  console.keyMap = "us";

}
