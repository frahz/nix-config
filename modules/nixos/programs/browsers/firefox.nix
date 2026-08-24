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
        ".mozilla/firefox/frahz/chrome/userChrome.css".text = /* css */ ''
          .tab-group-label {
            /* Don't change the text color or add an outline when tab groups are collapsed (makes the above usable) */
            tab-group[collapsed] > .tab-group-label-container & {
              /* Don't invert the color of tab groups when they're collapsed */
              background-color: var(--tab-group-color) !important;
              color: light-dark(
                var(--tab-group-color-pale),
                var(--tab-group-label-text-dark)
              ) !important;
              outline: none !important;
            }

            /* Hide labels when vertical tabs sidebar isn't expanded */
            #tabbrowser-tabs[orient="vertical"]:not([expanded]) & {
              &::first-letter {
                font-size: 0px !important;
              }
            }
          }

          /* Don't invert the color of tab groups when shown as suggestion in url bar */
          .urlbarView-row[has-action]:is(
            [type="switchtab"],
            [type="remotetab"],
            [type="clipboard"]
          ) > .urlbarView-row-inner
            > .urlbarView-no-wrap
            > .urlbarView-action.urlbarView-tabGroup {
            background-color: var(--tab-group-color) !important;
          }

          @media not -moz-pref("browser.nova.enabled") {
            .urlbarView-action-btn {
              &[data-action^="tabgroup-"] {
                background-color: var(--tab-group-color) !important;
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
