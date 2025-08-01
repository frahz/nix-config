{ lib, config, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.casa.profiles.graphical.enable {
    environment.variables = {
      NIXOS_OZONE_WL = "1";
      _JAVA_AWT_WM_NONEREPARENTING = "1";
      GDK_BACKEND = "wayland,x11";
      MOZ_ENABLE_WAYLAND = "1";
      XDG_SESSION_TYPE = "wayland";

      # use wayland for QT apps
      QT_QPA_PLATFORM = "wayland";

      # no window decorations
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      # no scaling
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    };
  };
}
