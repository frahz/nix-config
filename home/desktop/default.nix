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
    libsForQt5.dolphin
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
