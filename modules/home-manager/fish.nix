{ config, pkgs, inputs, ... }:

{
  programs.fish = {
    enable = true;
    shellInit = ''
      set -g fish_key_bindings fish_vi_key_bindings
      neofetch
    '';
  };
}
