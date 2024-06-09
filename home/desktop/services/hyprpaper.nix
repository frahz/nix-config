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
      ];
      wallpaper = [
        "HDMI-A-1,~/Pictures/wl2.png"
      ];
    };
  };
}
