{
  pkgs,
  inputs,
  ...
}: let
  hyprpaper = inputs.hyprpaper.packages.${pkgs.system}.default;
in {
  home.packages = [hyprpaper];

  services.hyprpaper = {
    enable = true;
    package = hyprpaper;
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
