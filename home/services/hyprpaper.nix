{ osConfig, pkgs, ... }:
{
  home.packages = [ pkgs.hyprpaper ];

  services.hyprpaper = {
    inherit (osConfig.casa.profiles.graphical) enable;
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
}
