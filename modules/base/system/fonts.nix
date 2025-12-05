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

      inter
      roboto

      # Monospace
      jetbrains-mono

      noto-fonts
      noto-fonts-cjk-sans

      # Emojis
      noto-fonts-color-emoji
      material-icons
      material-design-icons
      ;

    inherit (pkgs.nerd-fonts) symbols-only;

    inherit (inputs.privado.packages.${pkgs.stdenv.hostPlatform.system})
      berkeley-mono
      berkeley-mono-semi-condensed
      ;
  };
}
