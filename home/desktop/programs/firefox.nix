{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    policies = {
      DisablePocket = true;
      OfferToSaveLogins = true;
      PasswordManagerEnable = false;
    };
    profiles.frahz = {
      id = 0;
      isDefault = true;
      name = "frahz";
    };
  };
}
