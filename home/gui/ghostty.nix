{ pkgs, osConfig, ... }:
{
  programs.ghostty = {
    inherit (osConfig.casa.profiles.graphical) enable;
    # FIXME: ghostty is broken on darwin
    package = if pkgs.stdenv.hostPlatform.isLinux then pkgs.ghostty else null;

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
