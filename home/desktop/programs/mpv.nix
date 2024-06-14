{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    catppuccin.enable = true;
    config = {
      osc = "no";
      border = "no";
    };
    scripts = with pkgs.mpvScripts; [
      modernx
    ];
  };
  xdg.mimeApps.defaultApplications = {
    "audio/*" = ["mpv.desktop"];
    "video/*" = ["mpv.dekstop"];
  };
}
