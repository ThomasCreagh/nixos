{ config, pkgs, ... }:

{
  users.users.syncthing = {
    isSystemUser = true;
    group = "syncthing";
  };

  services.syncthing = {
    enable = true;
    user = "tom";
    guiAddress = "0.0.0.0:8384";
    dataDir = "/home/tom";
    settings = {
      options.urAccepted = -1;
      devices = {
        phone = {
          addresses = [ "157.90.171.125:22067" ];
          id = "LI52QQ5-437KNEK-AI2XKKP-FTAHE6Q-CMS6S2H-PKL2ZWI-3BSIPIC-DAIPCQH";
        };
      };
      folders = {
        "/home/tom/Sync" = {
          id = "t6ycq-p4mmn";
          devices = [ "phone" ];
        };
      };
    };
  };
}
