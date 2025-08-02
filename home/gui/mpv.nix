{ osConfig, pkgs, ... }:
{
  programs.mpv = {
    inherit (osConfig.casa.profiles.graphical) enable;
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
    "audio/*" = [ "mpv.desktop" ];
    "video/*" = [ "mpv.dekstop" ];
  };
}
