{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;
    packages = with pkgs; [
      iosevka
      (nerdfonts.override {
        fonts = ["IosevkaTerm"];
      })
      noto-fonts
      noto-fonts-cjk
      twitter-color-emoji
    ];

    fontconfig = {
      enable = true;
      allowBitmaps = true;
      defaultFonts = {
        monospace = ["Iosevka Term NF" "Twitter Color Emoji"];
        serif = ["Noto Serif" "Twitter Color Emoji"];
        sansSerif = ["Noto Sans" "Twitter Color Emoji"];
        emoji = ["Twitter Color Emoji"];
      };
      hinting = {
        enable = true;
        style = "slight";
      };
    };
  };
}
