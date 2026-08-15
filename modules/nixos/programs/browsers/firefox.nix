{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) singleton;

  cfg = config.casa.profiles.graphical;
  settings = {
    "app.normandy.enabled" = false;
    "app.normandy.api_url" = "";
    "app.shield.optoutstudies.enabled" = false;
    "browser.discovery.enabled" = false;
    "browser.ping-centre.telemetry" = false;
    "browser.startup.page" = 3;
    "dom.private-attribution.submission.enabled" = false;
    "experiments.enabled" = false;
    "experiments.manifest.uri" = "";
    "experiments.supported" = false;
    "toolkit.coverage.endpoint.base" = "";
    "toolkit.coverage.opt-out" = true;
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.coverage.opt-out" = true;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.server" = "data:,";
    "toolkit.telemetry.unified" = false;
  };
  userJs = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (
      name: value: "user_pref(${builtins.toJSON name}, ${builtins.toJSON value});"
    ) settings
  );
in
{
  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      policies = {
        DisablePocket = true;
        DisplayBookmarksToolbar = true;
        DNSOverHTTPS.Enabled = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        PasswordManagerEnable = false;
      };
    };

    hjem.users.frahz = {
      packages = singleton pkgs.firefox;

      files = {
        ".mozilla/firefox/profiles.ini".text = ''
          [General]
          StartWithLastProfile=1
          Version=2

          [Profile0]
          Default=1
          IsRelative=1
          Name=frahz
          Path=frahz
        '';
        ".mozilla/firefox/frahz/user.js".text = userJs + "\n";
        ".mozilla/firefox/frahz/chrome/userChrome.css".text = ''
          /* Don't invert the color of tab groups when they're collapsed */
          tab-group {
            --tab-group-color: var(--tab-group-color-invert) !important;
          }

          .tab-group-label {
            tab-group[collapsed] > .tab-group-label-container & {
              color: light-dark(var(--tab-group-color-pale), var(--tab-group-label-text-dark)) !important;
              outline: none !important;
            }

            #tabbrowser-tabs[orient="vertical"]:not([expanded]) & {
              &::first-letter {
                font-size: 0px !important;
              }
            }
          }
        '';
      };

      xdg.mime-apps.default-applications = {
        "text/html" = singleton "firefox.desktop";
        "x-scheme-handler/about" = singleton "firefox.desktop";
        "x-scheme-handler/ftp" = singleton "firefox.desktop";
        "x-scheme-handler/http" = singleton "firefox.desktop";
        "x-scheme-handler/https" = singleton "firefox.desktop";
        "x-scheme-handler/unknown" = singleton "firefox.desktop";
      };
    };
  };
}
