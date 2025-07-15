{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    policies = {
      DisablePocket = true;
      PasswordManagerEnable = false;
      DisplayBookmarksToolbar = true;
      DontCheckDefaultBrowser = true;
      OfferToSaveLogins = false;
      NoDefaultBookmarks = true;
      DNSOverHTTPS = {
        Enabled = true;
      };
    };
    profiles.frahz = {
      id = 0;
      isDefault = true;
      name = "frahz";
      settings = {
        # 0 => blank page
        # 1 => your home page(s) {default}
        # 2 => the last page viewed in Firefox
        # 3 => previous session windows and tabs
        "browser.startup.page" = 3;

        # Disable some tracking
        # https://mozilla.github.io/normandy/
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        "app.shield.optoutstudies.enabled" = false;
        "browser.discovery.enabled" = false;
        "dom.private-attribution.submission.enabled" = false;
        # telemetry
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.coverage.opt-out" = true;
        "toolkit.coverage.endpoint.base" = "";
        "experiments.supported" = false;
        "experiments.enabled" = false;
        "experiments.manifest.uri" = "";
        "browser.ping-centre.telemetry" = false;
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
    "x-scheme-handler/ftp" = [ "firefox.desktop" ];
    "x-scheme-handler/about" = [ "firefox.desktop" ];
    "x-scheme-handler/unknown" = [ "firefox.desktop" ];
  };
}
