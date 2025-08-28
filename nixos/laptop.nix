{ config, pkgs, ... }:

{
  imports =
    [
      ./laptop-hardware.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  console.keyMap = "us";

}
