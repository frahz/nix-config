{
  fonts = {
    enableDefaultPackages = false;
    fontDir = {
      enable = true;
      decompressFonts = true;
    };

    fontconfig = {
      enable = true;
      allowBitmaps = true;
      defaultFonts =
        let
          symbols = [
            "Noto Color Emoji"
            "Symbols Nerd Font"
            "Noto Sans Symbols"
            "Noto Sans Symbols 2"
          ];
        in
        {
          monospace = [ "Berkeley Mono" ] ++ symbols;
          serif = [ "Noto Serif" ] ++ symbols;
          sansSerif = [ "Inter" ] ++ symbols;
          emoji = symbols;
        };
    };
  };
}
