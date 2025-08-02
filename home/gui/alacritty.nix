{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = osConfig.casa;
in
{
  config = mkIf (cfg.profiles.graphical.enable && isLinux) {
    programs.alacritty = {
      enable = true;
      settings = {
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
          normal.family = "Berkeley Mono SemiCondensed";
          bold.family = "Berkeley Mono SemiBold SemiCondensed";
          size = 12;
        };
      };
    };
    catppuccin.alacritty.enable = true;
  };
}
