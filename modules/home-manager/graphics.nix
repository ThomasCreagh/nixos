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
  # Light mode from sunrise to sunset, dark otherwise. Sun times are
  # calculated locally from fixed coordinates (centre of Ireland, near
  # Athlone), so no location lookup or network is needed. Apps that follow
  # the system theme pick up the change through the settings portal.
  services.darkman = {
    enable = true;
    settings = {
      lat = 53.42;
      lng = -7.94;
      usegeoclue = false;
    };
    lightModeScripts.color-scheme = ''
      ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'default'"
    '';
    darkModeScripts.color-scheme = ''
      ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
    '';
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
