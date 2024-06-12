{
  lib,
  pkgs,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings =
      {
        env = {
          TERM = "xterm-256color";
        };
        window = {
          decorations = "none";
          dynamic_padding = true;
          padding = {
            x = 5;
            y = 5;
          };
          startup_mode = "Maximized";
        };

        scrolling.history = 10000;

        font = {
          normal.family = "Iosevka NF";
          bold.family = "Iosevka NF";
          size = 12;
        };
      }
      // (
        lib.importTOML (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/alacritty/94800165c13998b600a9da9d29c330de9f28618e/catppuccin-mocha.toml";
          hash = "sha256-/N3rwIZ0SJBiE7TiBs4pEjhzM1f2hr26WXM3ifUzzOY=";
        })
      );
  };
}