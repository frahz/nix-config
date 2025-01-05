{
  inputs,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
      font-family = "Iosevka Term";
      gtk-titlebar = false;
      window-padding-x = 4;
      window-padding-y = 4;
    };
  };
}
