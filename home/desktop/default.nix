{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./alacritty.nix
    ./firefox.nix
    ./hyprland
    ./rofi
    ./waybar
    ./services/hyprpaper.nix
    ./hyprlock.nix
  ];

  home.packages = with pkgs; [
    anki-bin
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
}
