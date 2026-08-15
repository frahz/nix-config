{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkDefault;
  inherit (lib.lists) singleton;
in
{
  xdg.portal = {
    enable = mkDefault config.casa.profiles.graphical.enable;
    xdgOpenUsePortal = true;

    config.common = {
      default = [
        "hyprland"
        "gtk"
      ];
      "org.freedesktop.impl.portal.Secret" = singleton "gnome-keyring";
    };

    extraPortals = singleton pkgs.xdg-desktop-portal-gtk;
  };
}
