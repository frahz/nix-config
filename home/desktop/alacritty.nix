{
  lib,
  pkgs,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings =
      {
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
          normal.family = "Iosevka";
          bold.family = "Iosevka";
          size = 11;
        };
      }
      // (
        lib.importTOML (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/alacritty/94800165c13998b600a9da9d29c330de9f28618e/catppuccin-mocha.toml";
          hash = "";
        })
      );
  };
}
