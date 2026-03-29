{ config, pkgs, inputs, ... }:

{
  # notifications
  services.mako = { 
    enable = true;
    settings = {
      "actionable=true" = {
        anchor = "top-left";
      };
      actions = true;
      anchor = "top-right";
      background-color = "#3a5760";
      border-color = "#a1d1cc";
      border-radius = 10;
      default-timeout = 0;
      height = 100;
      icons = true;
      ignore-timeout = false;
      layer = "top";
      margin = 10;
      markup = true;
      width = 300;
    };
  };
}
