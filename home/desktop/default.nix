{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./programs
    ./utils
    ./hyprland
    ./hyprland/programs/hyprlock.nix
    ./hyprland/services/hyprpaper.nix
    ./hyprland/services/hypridle.nix
  ];

  home.packages = with pkgs; [
    anki-bin
    dconf
    xfce.thunar # file manager for now
    gimp
    ffmpeg
    hyprpicker
    miru
    vesktop
  ];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 18;
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps.enable = true;
  };
}
