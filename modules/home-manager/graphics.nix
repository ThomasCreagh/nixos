{ config, pkgs, inputs, ... }:

{
  home.pointerCursor = {
    enable = true;
    package = pkgs.vanilla-dmz;
    name = "DMZ-White";
    size = 24;
    gtk.enable = true;
  };
  programs.feh.enable = true; # image viewer

  gtk = {
    enable = true;
    theme.name = "Adwaita";
    iconTheme.name = "Adwaita";
    font.name = "Cantarell 14";
    gtk4.theme = null;
  };
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "Breeze";
  };
  xresources.properties = {
    "Xft.dpi" = 144;
  };
}
