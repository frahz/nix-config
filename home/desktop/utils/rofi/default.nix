{pkgs, ...}: {
  imports = [./powermenu];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "Iosevka NF 14";
    extraConfig = {
      drun-display-format = " {name} ";
      show-icons = true;

      display-drun = "";
    };
    theme = ./theme.rasi;
  };
}
