{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) singleton;
  cfg = config.casa.profiles.graphical;
  sources = config.catppuccin.sources;
in
{
  config = lib.mkIf cfg.enable {
    hjem.users.frahz = {
      packages = singleton pkgs.alacritty;

      xdg.config.files."alacritty/alacritty.toml" = {
        generator = (pkgs.formats.toml { }).generate "alacritty.toml";
        value = {
          env.TERM = "xterm-256color";
          font = {
            bold.family = "Berkeley Mono SemiBold SemiCondensed";
            normal.family = "Berkeley Mono SemiCondensed";
            size = 12;
          };
          general.import = singleton "${sources.alacritty}/catppuccin-mocha.toml";
          scrolling.history = 10000;
          window = {
            decorations = "none";
            dynamic_padding = true;
            padding = {
              x = 5;
              y = 5;
            };
            startup_mode = "Maximized";
          };
        };
      };
    };
  };
}
