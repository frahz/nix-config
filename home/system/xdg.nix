{
  osConfig,
  ...
}:
let

  cfg = osConfig.casa;
in
{
  xdg = {
    inherit (cfg.profiles.graphical) enable;
    mime.enable = cfg.profiles.graphical.enable;
    mimeApps = {
      inherit (cfg.profiles.graphical) enable;
      defaultApplications = {
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
        "x-scheme-handler/spotify" = [ "spotify.desktop" ];
        "x-scheme-handler/discord" = [ "vesktop.desktop" ];
      };
    };
  };
}
