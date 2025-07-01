{
  inputs,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;
    # https://github.com/ghostty-org/ghostty/discussions/7720
    # until fixed in next kernel release
    package = pkgs.ghostty.overrideAttrs (_: {
      preBuild = ''
        shopt -s globstar
        sed -i 's/^const xev = @import("xev");$/const xev = @import("xev").Epoll;/' **/*.zig
        shopt -u globstar
      '';
    });
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
