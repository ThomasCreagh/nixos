{ config, pkgs, ... }:

{
  imports =
    [
      ./laptop-hardware.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
	#boot.kernelParams = [
  	#  "amdgpu.runpm=0"
  	#  "amdgpu.deep_color=0"
  	#];

	#hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };

  services.logind.settings.Login.HandleLidSwitch = "ignore";
  services.logind.settings.Login.HandleLidSwitchDocked = "ignore";
  services.power-profiles-daemon.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  swapDevices = [
    {
      device = "/swapfile";
      size = 16384;
    }
  ];

  console.keyMap = "us";
}
