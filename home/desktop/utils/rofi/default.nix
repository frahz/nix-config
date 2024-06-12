{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "Iosevka 14";
    extraConfig = {
      drun-display-format = " {name} ";
      show-icons = true;

      display-drun = "";
    };
    theme = ./theme.rasi;
  };
}
