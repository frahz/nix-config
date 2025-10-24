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
          addAll = builtins.mapAttrs (
            _: v:
            v
            ++ [ "Twitter Color Emoji" ]
            ++ [
              "Symbols Nerd Font"
              "Noto Sans Symbols"
              "Noto Sans Symbols 2"
            ]
          );
        in
        addAll {
          monospace = [ "Berkeley Mono" ];
          serif = [ "Noto Serif" ];
          sansSerif = [ "Inter" ];
          emoji = [ ];
        };
    };
  };
}
