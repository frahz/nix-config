{ pkgs, ... }:
{
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
}
