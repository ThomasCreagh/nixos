{ config, pkgs, inputs, ... }:

{
  # browser
  programs.firefox = {
    enable = true;
    policies = {
      Homepage = {
        URL = "https://nixos.org";
        Locked = true;
      };
      NewTabPage = false;
      DisableTelemetry = true;
    };

    profiles.default = {
      settings = {
        "browser.startup.homepage" = "https://nixos.org";
        "browser.search.defaultenginename" = "DuckDuckGo";
        "sidebar.verticalTabs" = "true";
        "browser.newtabpage.enabled" = "false";
        "browser.newtabpage.activity-stream.enabled" = "false";
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      userChrome = ''
        #personal-bookmarks #import-button {
          display: none !important;
        }
      '';
      extensions = {
        force = true;
        packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          sponsorblock
          youtube-shorts-block
          #vimium
        ];
      };
      bookmarks = {
        force = true;
        settings = [
          {
            name = "Toobar bookmarks";
            toolbar = true;
            bookmarks = [
              {
                name = "homepage";
                url = "https://nixos.org/";
              }
              {
                 name = "com";
                 bookmarks = [
                   {
                     name = "whatsapp";
                     url = "https://web.whatsapp.com";
                   }
                   {
                     name = "proton";
                     url = "https://proton.me";
                   }
                   {
                     name = "addy";
                     url = "https://addy.io";
                   }
                   {
                     name = "gmail";
                     url = "https://gmail.com";
                   }
                   {
                     name = "linkedin";
                     url = "https://linkedin.com";
                   }
                   {
                     name = "blackboard";
                     url = "https://tcd.blackboard.com/";
                   }
                 ];
              }
              {
                 name = "nixos";
                 bookmarks = [
                   {
                     name = "nix packages";
                     url = "https://search.nixos.org/packages";
                   }
                   {
                     name = "nix options";
                     url = "https://search.nixos.org/options?";
                   }
                   {
                     name = "nix flakes";
                     url = "https://search.nixos.org/flakes?";
                   }
                   {
                     name = "nix wiki";
                     url = "https://wiki.nixos.org/wiki/NixOS_Wiki";
                   }
                   {
                     name = "home-manager manual";
                     url = "https://nix-community.github.io/home-manager/";
                   }
                 ];
              }
              {
                 name = "job";
                 bookmarks = [
                   {
                     name = "linkedin";
                     url = "https://www.linkedin.com/in/thomas-creagh/";
                   }
                   {
                     name = "github";
                     url = "https://github.com/ThomasCreagh";
                   }
                   {
                     name = "personal website";
                     url = "https://thomascreagh.github.io";
                   }
                 ];
              }
              {
                 name = "prog misc";
                 bookmarks = [
                   {
                     name = "css docs";
                     url = "https://developer.mozilla.org/en-US/docs";
                   }
                   {
                     name = "how to make a proxy server";
                     url = "https://medium.com/@davesohamm/constructing-a-multithreaded-proxy-web-server-in-c-a-technical-perspective-e2126501d8bb";
                   }
                 ];
              }
              {
                 name = "zig";
                 bookmarks = [
                   {
                     name = "zig";
                     url = "https://ziglang.org";
                   }
                 ];
              }
              {
                 name = "cheatsheets";
                 bookmarks = [
                   {
                     name = "firefox";
                     url = "https://support.mozilla.org/en-US/kb/keyboard-shortcuts-perform-firefox-tasks-quickly?redirectslug=Keyboard+shortcuts&redirectlocale=en-US";
                   }
                   {
                     name = "tmux";
                     url = "https://tmuxcheatsheet.com/";
                   }
                 ];
              }
              {
                 name = "maths";
                 bookmarks = [
                   {
                     name = "detexify";
                     url = "https://detexify.kirelabs.org/classify.html";
                   }
                 ];
              }
            ];
          }
        ];
      };
      search = {
        force = true;
        default = "ddg";
        order = [ "ddg" ];
        engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "NixOS Wiki" = {
            urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
            icon = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@nw" ];
          };
          "ddg" = {
            urls = [{ template = "https://duckduckgo.com/?t=h_&q={searchTerms}&ia=web"; }];
            icon = "https://duckduckgo.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@dk" ];
          };
        };
      };
    };
  };
}
