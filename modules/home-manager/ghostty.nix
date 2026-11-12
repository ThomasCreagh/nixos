{ config, pkgs, inputs, ... }:

{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    installVimSyntax = true;
    settings = {
      font-size = 20;
      # Follows the system light/dark preference (switched by darkman)
      theme = "light:TokyoNight Day,dark:TokyoNight Night";
    };
  };
}
