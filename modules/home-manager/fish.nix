{ config, pkgs, inputs, ... }:

{
  programs.fish = {
    enable = true;
    functions = {
      dn = {
        description = "Go up N directories";
        body = ''
          if test (count $argv) -lt 1
            echo "Usage: dn <number of dirs up>"
            return 1
          end

          cd (string repeat -n $argv[1] "../" | string trim)
        '';
      };
    };
    shellInit = ''
      set -g fish_key_bindings fish_vi_key_bindings
      fastfetch
    '';

  };
}
