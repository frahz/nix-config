{pkgs, ...}: {
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
      };
    };
  };
}
