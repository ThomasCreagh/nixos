{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    extraPackages = [ pkgs.docker-buildx ];
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };
}
