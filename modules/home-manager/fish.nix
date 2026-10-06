{ config, pkgs, inputs, ... }:

{
  programs.fish = {
    enable = true;
    functions = {
      dn = {
        description = "Go up N directories";
        body = ''
          if test (count $argv) -lt 1
            cd ..
            return 0
          end

          cd (string repeat -n $argv[1] "../" | string trim)
        '';
      };
    };
    interactiveShellInit = ''
      set -g fish_greeting
    '';
    shellInit = ''
      set -g fish_key_bindings fish_vi_key_bindings
    '';
      #fastfetch
  };
}
