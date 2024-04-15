{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./alacritty.nix
    ./firefox.nix
    ./hyprland
  ];

  home.packages = with pkgs; [
    anki-bin
    gimp
    ffmpeg
  ];
}
