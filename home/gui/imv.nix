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
    programs.imv = {
      enable = true;
    };
    catppuccin.imv.enable = true;

    xdg.mimeApps.defaultApplications = {
      "image/gif" = [ "imv.desktop" ];
      "image/png" = [ "imv.desktop" ];
      "image/apng" = [ "imv.desktop" ];
      "image/avif" = [ "imv.desktop" ];
      "image/jpeg" = [ "imv.desktop" ];
      "image/webp" = [ "imv.desktop" ];
      "image/svg+xml" = [ "imv.desktop" ];
    };
  };
}
