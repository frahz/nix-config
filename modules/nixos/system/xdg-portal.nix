{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  xdg.portal = {
    enable = mkDefault config.casa.profiles.graphical.enable;

    xdgOpenUsePortal = true;

    config.common.default = "*";

    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
