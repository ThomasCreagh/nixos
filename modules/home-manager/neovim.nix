{ config, pkgs, inputs, ... }:

{
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
  };
  home.file.".config/nvim".source = ../../extra-config/nvim;
}
