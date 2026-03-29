{ config, pkgs, ... }:

{
  services = {
    gnome.gnome-keyring.enable = true;
    libinput = {
      enable = true;
      touchpad.sendEventsMode = "disabled";
    };
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
      extraUpFlags = [ "--accept-routes" ];
    };
  };

  networking = {
    networkmanager.enable = true;
    nat = {
      enable = true;
      internalInterfaces = ["virbr0"];
      externalInterface = "wlp5s0";
    };
    firewall = {
      trustedInterfaces = [ "wlp5s0" "virbr0" ];
      allowedTCPPorts = [ 8384 ];
      allowedUDPPorts = [ 41641 ];
    };
    hostName = "nixos";
  };
}
