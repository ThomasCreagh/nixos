{ config, pkgs, inputs, ... }:

{
  imports = [
    ../modules/home-manager/firefox.nix
    ../modules/home-manager/fish.nix
    ../modules/home-manager/ghostty.nix
    ../modules/home-manager/git.nix
    ../modules/home-manager/graphics.nix
    ../modules/home-manager/hyprland.nix
    ../modules/home-manager/mako.nix
    ../modules/home-manager/neovim.nix
    ../modules/home-manager/packages.nix
    ../modules/home-manager/waybar.nix
    ../modules/home-manager/wofi.nix
  ];
  home = {
    username = "tom";
    homeDirectory = "/home/tom";
    stateVersion = "25.05";
    sessionVariables = {
      EDITOR = "nvim";
      LV2_PATH = "${pkgs.lv2}/lib/lv2:/run/current-system/sw/lib/lv2:/nix/store/m9hwvnfv5x2xai34i9aymmxz7v2sbaln-helm-0.9.0/lib/lv2";
      VST_PATH = "/run/current-system/sw/lib/vst";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
