{
  inputs,
  pkgs,
  ...
}: {
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;
    packages = with pkgs; [
      iosevka
      (pkgs.iosevka-bin.override {variant = "Slab";})
      (nerdfonts.override {
        fonts = ["Iosevka"];
      })
      noto-fonts
      noto-fonts-cjk
      twitter-color-emoji

      inputs.apple-fonts.packages.${pkgs.system}.ny
    ];

    fontconfig = {
      enable = true;
      allowBitmaps = true;
      defaultFonts = {
        monospace = ["Iosevka NF" "Twitter Color Emoji"];
        serif = ["Noto Serif" "Twitter Color Emoji"];
        sansSerif = ["Noto Sans" "Twitter Color Emoji"];
        emoji = ["Twitter Color Emoji"];
      };
    };
  };
}
