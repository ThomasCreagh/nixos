{ config, pkgs, inputs, ... }:

{
  programs.git = {
    enable = true;
    settings.user = {
      name = "Thomas Creagh";
      email = "github@thomascreagh.mailer.me";
    };
  };
}
