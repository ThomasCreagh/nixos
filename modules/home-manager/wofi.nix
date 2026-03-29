{ config, pkgs, inputs, ... }:

{
  # application search
  programs.wofi = {
    enable = true;
    style = ''
      window {
        background-color: #1a1b26;
        color: #c0caf5;
      }
      #input {
        background-color: #1a1b26;
        color: #c0caf5;
        border: none;
      }
    '';
  };
}
