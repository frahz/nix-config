{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  fonts.packages = lib.attrValues {
    inherit (pkgs)
      source-sans
      source-serif

      dejavu_fonts
      inter
      roboto

      # Monospace
      jetbrains-mono
      iosevka-bin

      noto-fonts
      noto-fonts-cjk-sans

      # Emojis
      twitter-color-emoji
      noto-fonts-color-emoji
      material-icons
      material-design-icons
      ;
    iosevka-slab = pkgs.iosevka-bin.override {
      variant = "Slab";
    };

    inherit (pkgs.nerd-fonts) symbols-only;

    inherit (inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system})
      ny
      ;

    inherit (inputs.private-flake.packages.${pkgs.stdenv.hostPlatform.system})
      berkeley-mono
      berkeley-mono-semi-condensed
      ;
  };
}
