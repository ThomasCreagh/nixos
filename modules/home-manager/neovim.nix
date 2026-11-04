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

    extraPackages = with pkgs; [
      nixd
      tree-sitter
    ];
  };
  home.file.".config/nvim".source = ../../extra-config/nvim;
}
