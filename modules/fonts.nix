{
  inputs,
  pkgs,
  ...
}: {
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;
    packages = with pkgs; [
      corefonts

      source-sans
      source-serif

      dejavu_fonts
      inter

      iosevka
      (pkgs.iosevka-bin.override {variant = "Slab";})
      (nerdfonts.override {
        fonts = ["Iosevka"];
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
      defaultFonts = {
        monospace = ["Iosevka NF" "Noto Sans Symbols" "Noto Sans Symbols2"];
        serif = ["Noto Serif" "Twitter Color Emoji"];
        sansSerif = ["Noto Sans" "Twitter Color Emoji"];
        emoji = ["Twitter Color Emoji"];
      };
    };
  };
}
