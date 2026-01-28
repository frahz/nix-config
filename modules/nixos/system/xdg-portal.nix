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

    config.common = {
      default = [ "hyprland" "gtk" ];

      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };

    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
