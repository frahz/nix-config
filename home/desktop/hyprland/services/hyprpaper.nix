{pkgs, ...}: {
  home.packages = [pkgs.hyprpaper];

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = true;
      splash = false;
      preload = [
        "~/Pictures/wl.jpg"
        "~/Pictures/wl2.png"
        "~/Pictures/GP2qRG5bAAAuXOa.jpg"
      ];
      wallpaper = [
        "HDMI-A-1,~/Pictures/GP2qRG5bAAAuXOa.jpg"
      ];
    };
  };
}
