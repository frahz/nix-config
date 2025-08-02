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
    programs.zathura = {
      enable = true;
    };
    catppuccin.zathura.enable = true;
    xdg.mimeApps.defaultApplications = {
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
    };
  };
}
