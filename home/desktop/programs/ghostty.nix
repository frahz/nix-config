{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.ghostty.packages.${pkgs.system}.default
  ];

  xdg.configFile."ghostty/config".text = ''
    theme = catppuccin-mocha

    window-padding-x = 4,4
    window-padding-y = 4,4

    gtk-titlebar = false
    font-family = Iosevka Term
  '';
}
