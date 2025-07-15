_: {
  programs.imv = {
    enable = true;
  };
  catppuccin.imv.enable = true;

  xdg.mimeApps.defaultApplications = {
    "image/gif" = [ "imv.desktop" ];
    "image/png" = [ "imv.desktop" ];
    "image/apng" = [ "imv.desktop" ];
    "image/avif" = [ "imv.desktop" ];
    "image/jpeg" = [ "imv.desktop" ];
    "image/webp" = [ "imv.desktop" ];
    "image/svg+xml" = [ "imv.desktop" ];
  };
}
