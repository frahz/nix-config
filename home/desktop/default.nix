{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./programs
    ./utils
    ./hyprland
    ./hyprland/services/hyprpaper.nix
    ./hyprland/programs/hyprlock.nix
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
