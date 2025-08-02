{
  pkgs,
  osConfig,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = osConfig.casa;
in
{
  home.pointerCursor = {
    enable = cfg.profiles.graphical.enable && isLinux;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 22;
    gtk.enable = true;
  };

}
