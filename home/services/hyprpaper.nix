{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = osConfig.casa;
in
{
  config = mkIf (cfg.profiles.graphical.enable && isLinux) {
    home.packages = [ pkgs.hyprpaper ];

    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = true;
        splash = false;
        preload = [
          "~/Pictures/wl.jpg"
          "~/Pictures/wl2.png"
          "~/Pictures/GP2qRG5bAAAuXOa.jpg"
          "~/Pictures/camille-villanueva-zsAPsRjzXRI-unsplash.jpg"
        ];
        wallpaper = [
          "HDMI-A-1,~/Pictures/camille-villanueva-zsAPsRjzXRI-unsplash.jpg"
        ];
      };
    };
  };
}
