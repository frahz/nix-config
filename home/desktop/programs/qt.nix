{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libsForQt5.qt5ct
    breeze-icons
    qt6Packages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
  ];
  qt = {
    enable = true;
    platformTheme = "qtct";
    style = {
      name = "kvantum";
      catppuccin.enable = true;
    };
  };
}
