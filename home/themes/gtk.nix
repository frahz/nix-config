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
    home.packages = [ pkgs.glib ];
    gtk = {
      enable = true;

      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgb";
        gtk-enable-event-sounds = 0;
        gtk-enable-input-feedback-sounds = 0;
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgb";
        gtk-enable-event-sounds = 0;
        gtk-enable-input-feedback-sounds = 0;
      };

      gtk2.extraConfig = ''
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle="hintslight"
        gtk-xft-rgba="rgb"
        gtk-enable-event-sounds=0
        gtk-enable-input-feedback-sounds=0
      '';
    };

    catppuccin.gtk.icon.enable = true;
  };
}
