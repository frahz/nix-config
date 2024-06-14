_: {
  programs.zathura = {
    enable = true;
    catppuccin.enable = true;
  };
  xdg.mimeApps.defaultApplications = {
    "application/pdf" = ["org.pwmt.zathura.desktop.desktop"];
  };
}
