_: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
      font-family = "Berkeley Mono";
      font-style = "SemiCondensed";
      font-style-bold = "SemiBold SemiCondensed";
      font-style-italic = "SemiCondensed Oblique";
      font-style-bold-italic = "SemiBold SemiCondensed Oblique";
      gtk-titlebar = false;
      window-padding-x = 4;
      window-padding-y = 4;
    };
  };
}
