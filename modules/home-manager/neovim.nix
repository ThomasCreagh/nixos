{ config, pkgs, inputs, ... }:

{
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    withRuby = false;
    withPython3 = false;
  };
  home.file.".config/nvim".source = ../../extra-config/nvim;
}
