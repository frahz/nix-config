_: {
  programs.zathura = {
    enable = true;
  };
  catppuccin.zathura.enable = true;
  xdg.mimeApps.defaultApplications = {
    "application/pdf" = ["org.pwmt.zathura.desktop"];
  };
}
