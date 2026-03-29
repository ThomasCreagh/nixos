{ config, pkgs, inputs, ... }:

{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    installVimSyntax = true;
    settings = {
      font-size = 20;
      theme = "TokyoNight Night";
    };
  };
}
