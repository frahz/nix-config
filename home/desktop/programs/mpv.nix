{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    config = {
      osc = "no";
      border = "no";
    };
    scripts = with pkgs.mpvScripts; [
      modernx
    ];
  };
  catppuccin.mpv.enable = true;
  xdg.mimeApps.defaultApplications = {
    "audio/*" = ["mpv.desktop"];
    "video/*" = ["mpv.dekstop"];
  };
}
