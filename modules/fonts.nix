{
  inputs,
  pkgs,
  ...
}: {
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;
    packages = with pkgs; [
      source-sans
      source-serif

      dejavu_fonts
      inter

      jetbrains-mono
      iosevka
      (pkgs.iosevka-bin.override {
        variant = "Slab";
      })
      (nerdfonts.override {
        fonts = ["NerdFontsSymbolsOnly"];
      })

      noto-fonts
      noto-fonts-cjk
      twitter-color-emoji
      noto-fonts-color-emoji

      material-icons
      material-design-icons

      inputs.apple-fonts.packages.${pkgs.system}.ny
    ];

    fontconfig = {
      enable = true;
      allowBitmaps = true;
      defaultFonts = let
        addAll = builtins.mapAttrs (_: v: v ++ ["Twitter Color Emoji"] ++ ["Symbols Nerd Font" "Noto Sans Symbols" "Noto Sans Symbols 2"]);
      in
        addAll {
          monospace = ["Iosevka"];
          serif = ["Noto Serif"];
          sansSerif = ["Inter"];
          emoji = [];
        };
    };
  };
}
