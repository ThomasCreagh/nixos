{ config, pkgs, inputs, ... }:

let
  c = import ./colors.nix;
in
{
  # notifications
  services.mako = {
    enable = true;
    settings = {
      "actionable=true" = {
        anchor = "top-left";
      };
      # Urgent notifications stay until dismissed
      "urgency=high" = {
        border-color = c.red;
        default-timeout = 0;
      };
      actions = true;
      anchor = "top-right";
      background-color = c.background;
      text-color = c.text;
      border-color = c.blue;
      border-size = 1;
      border-radius = 8;
      font = "JetBrainsMono Nerd Font 11";
      padding = 10;
      default-timeout = 8000;
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
